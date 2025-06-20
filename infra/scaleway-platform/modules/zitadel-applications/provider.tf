terraform {
  required_providers {
    zitadel = {
      source  = "zitadel/zitadel"
      version = "2.2.0"
    }
  }
}

provider "zitadel" {
  domain           = "zitadel.exoscale.playground.dataminded.cloud"
  insecure         = "true"
  jwt_profile_file = var.jwt_profile
}

