variable "region" {
  default = "eu-central-1"
}

variable "env" {
  default = "stage"
}

variable "vpc_cidr" {
}

variable "availability_zone1" {
}
variable "availability_zone2" {
}
variable "availability_zone3" {
}

variable "subnet_ecs1_cidr" {
}
variable "subnet_ecs2_cidr" {
}
variable "subnet_ecs3_cidr" {
}

variable "asg_ecs_instance_type" {}
variable "ecs_asg_min_size" {}
variable "ecs_asg_max_size" {}
variable "ecs_asg_desired_capacity" {}
