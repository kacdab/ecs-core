resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.env}"
}

data "aws_ami" "ecs-optimized" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-2017.*.g-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # Amazon
}

data "template_file" "user-data-ecs" {
  template = "${file("${path.module}/user-data/ecs.tpl")}"

  vars {
    ecs_cluster = "${aws_ecs_cluster.ecs-cluster.name}"
    region      = "${var.region}"
  }
}

resource "aws_launch_configuration" "asg-conf-ecs" {
  image_id                    = "${data.aws_ami.ecs-optimized.id}"
  instance_type               = "${var.asg_ecs_instance_type}"
  key_name                    = "${aws_key_pair.keypair-wh.key_name}"
  iam_instance_profile        = "${data.terraform_remote_state.core-infra-iam.iam_profile_ecs_instance_id}"
  security_groups             = ["${aws_security_group.sg-ecs.id}"]
  user_data                   = "${data.template_file.user-data-ecs.rendered}"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 15
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = 25
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-ecs" {
  name                      = "${format("%s-%s", "asg-ecs", var.env)}"
  vpc_zone_identifier       = ["${aws_subnet.subnet-ecs1.id}", "${aws_subnet.subnet-ecs2.id}", "${aws_subnet.subnet-ecs3.id}"]
  launch_configuration      = "${aws_launch_configuration.asg-conf-ecs.name}"
  min_size                  = "${var.ecs_asg_min_size}"
  max_size                  = "${var.ecs_asg_max_size}"
  desired_capacity          = "${var.ecs_asg_desired_capacity}"
  health_check_grace_period = 45
  health_check_type         = "EC2"
  default_cooldown          = 180

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }

  tag = [
    {
      "key"                 = "Name"
      "value"               = "${format("%s %s", "ECS instance", var.env)}"
      "propagate_at_launch" = true
    },
  ]
}
