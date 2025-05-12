terraform {
  required_providers {
    exoscale = {
      source = "exoscale/exoscale"
    }
  }
  backend "s3" {
    bucket         = "dp-stack-tf-state"
    key            = "exoscale-platform/terraform.tfstate"
    region         = "ch-gva-2"

    # Configuration for Exoscale SOS
    skip_region_validation = true
    skip_credentials_validation = true
    endpoint = "https://sos-${local.zone}.exo.io"
  }
}

provider "exoscale" {
  key    = var.exoscale_key
  secret = var.exoscale_secret
}