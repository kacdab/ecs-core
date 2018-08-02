resource "aws_security_group" "sg-ecs" {
  name        = "${format("%s-%s", "ECSSecurityGroup", var.env)}"
  description = "Allow all outbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "sg-ecs", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_security_group" "sg-bastion" {
  name        = "${format("%s-%s", "BastionSecurityGroup", var.env)}"
  description = "Allow all outbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "sg-bastion", var.env)}"
    Environment = "${var.env}"
  }

  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

resource "aws_security_group_rule" "sg-ecs-allow_tcp_22_from_office" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["87.239.222.13/32"]
  security_group_id = "${aws_security_group.sg-ecs.id}"
}

resource "aws_security_group_rule" "sg-ecs-allow_all_from_sg_bastion" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.sg-bastion.id}"
  security_group_id        = "${aws_security_group.sg-ecs.id}"
}

resource "aws_security_group_rule" "sg-ecs-allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-ecs.id}"
}

resource "aws_security_group_rule" "sg-bastion-allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-bastion.id}"
}
