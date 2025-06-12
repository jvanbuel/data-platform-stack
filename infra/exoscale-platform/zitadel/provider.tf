terraform {
  required_providers {
    zitadel = {
      source  = "zitadel/zitadel"
      version = "2.2.0"
    }
  }
}

provider "zitadel" {
  # Configuration options
  domain           = "localhost"
  insecure         = "true"
  port             = "8200"
  jwt_profile_file = "token.json"
}

provider "kubernetes" {
  config_path = "../app/exoscale.kubeconfig"

}