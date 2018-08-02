terraform {
  backend "s3" {
    bucket     = "wh-infra-global"
    key        = "iam/terraform.tfstate"
    region     = "eu-central-1"
    dynamodb_table = "wh-locks-global"
  }
}
