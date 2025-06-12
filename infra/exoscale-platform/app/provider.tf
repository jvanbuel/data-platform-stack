terraform {
  required_providers {
    exoscale = {
      source = "exoscale/exoscale"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
  backend "s3" {
    bucket = var.bucket_name
    key    = "exoscale-platform/terraform.tfstate"
    region = "ch-gva-2"

    # Configuration for Exoscale SOS: https://community.exoscale.com/community/storage/terraform/
    skip_region_validation      = true 
    skip_credentials_validation = true
    endpoint                    = "https://sos-${local.zone}.exo.io"
  }
}

provider "exoscale" {
  key    = var.exoscale_key
  secret = var.exoscale_secret
}


provider "aws" {

  endpoints {
    s3 = "https://sos-${local.zone}.exo.io"
  }

  region     = local.zone
  access_key = var.exoscale_key
  secret_key = var.exoscale_secret

  # Disable AWS-specific features: https://community.exoscale.com/community/storage/terraform/
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}


provider "kubernetes" {
  config_path = local_sensitive_file.kubeconfig.filename

}