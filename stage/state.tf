terraform {
  backend "s3" {
    bucket     = "wh-infra-stage"
    key        = "ecs/terraform.tfstate"
    region     = "eu-central-1"
    dynamodb_table = "wh-locks-stage"
  }
}
