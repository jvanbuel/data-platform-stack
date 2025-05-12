terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    
    required_version = ">= 1.0.0"
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