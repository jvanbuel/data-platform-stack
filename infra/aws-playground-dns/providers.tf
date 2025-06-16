terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }

    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.55.0"
    }
  }

  backend "s3" {
    bucket = "dp-stack-tf-state-upcloud"
    key    = "aws-playground-dns/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "scaleway" {
  zone            = "nl-ams-1"
  region          = "nl-ams"
  access_key      = var.scaleway_access_key
  secret_key      = var.scaleway_secret_key
  organization_id = var.scaleway_organization_id
  project_id      = var.scaleway_project_id
}
