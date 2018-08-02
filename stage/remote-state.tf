data "terraform_remote_state" "core-infra-iam" {
  backend = "s3"

  config {
    bucket = "wh-infra-global"
    key    = "iam/terraform.tfstate"
    region = "eu-central-1"
  }
}
