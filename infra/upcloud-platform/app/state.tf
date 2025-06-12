terraform {
  backend "s3" {
    bucket = "dp-stack-tf-state-upcloud"
    key    = "upcloud-platform/terraform.tfstate"
    region = "eu-west-1"
  }
}
