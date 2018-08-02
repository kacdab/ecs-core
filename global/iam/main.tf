resource "aws_iam_role_policy" "ecs-instance-policy" {
  name   = "ecs-instance-policy"
  role   = "${aws_iam_role.ecs-instance-role.id}"
  policy = "${file("${path.module}/policies/ecs-instance-role-policy.json")}"
}

resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  assume_role_policy = "${file("${path.module}/policies/ecs-instance-role.json")}"
}

resource "aws_iam_role_policy" "ecs-service-policy" {
  name   = "ecs-service-policy"
  role   = "${aws_iam_role.ecs-service-role.id}"
  policy = "${file("${path.module}/policies/ecs-service-role-policy.json")}"
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  assume_role_policy = "${file("${path.module}/policies/ecs-service-role.json")}"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  role = "${aws_iam_role.ecs-instance-role.id}"
}
