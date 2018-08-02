resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "ecs", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_internet_gateway" "ig-ecs" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "ig-ecs", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_subnet" "subnet-ecs1" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet_ecs1_cidr}"
  availability_zone = "${var.availability_zone1}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "subnet-ecs1", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_subnet" "subnet-ecs2" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet_ecs2_cidr}"
  availability_zone = "${var.availability_zone2}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "subnet-ecs2", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_subnet" "subnet-ecs3" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet_ecs3_cidr}"
  availability_zone = "${var.availability_zone3}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "subnet-ecs3", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_route_table" "rt-ecs1" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Terraform   = "True"
    Name        = "${format("%s-%s", "rt-ecs1", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_route" "route-ecs-1" {
  route_table_id         = "${aws_route_table.rt-ecs1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig-ecs.id}"
  depends_on             = ["aws_route_table.rt-ecs1"]
}

resource "aws_route_table_association" "rt-asso-ecs1" {
  subnet_id      = "${aws_subnet.subnet-ecs1.id}"
  route_table_id = "${aws_route_table.rt-ecs1.id}"
}

resource "aws_route_table_association" "rt-asso-ecs2" {
  subnet_id      = "${aws_subnet.subnet-ecs2.id}"
  route_table_id = "${aws_route_table.rt-ecs1.id}"
}

resource "aws_route_table_association" "rt-asso-ecs3" {
  subnet_id      = "${aws_subnet.subnet-ecs3.id}"
  route_table_id = "${aws_route_table.rt-ecs1.id}"
}

###########
# OUTPUTS #
###########

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
