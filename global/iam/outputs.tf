###########
# OUTPUTS #
###########

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs-service-role.arn}"
}

output "iam_profile_ecs_instance_id" {
  value = "${aws_iam_instance_profile.ecs-instance-profile.id}"
}
