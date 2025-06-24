terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    zitadel = {
      source  = "zitadel/zitadel"
      version = "2.2.0"
    }
  }
}
provider "kubernetes" {
  config_path = "${path.module}/../.kubeconfig.yml"
}

provider "helm" {
    kubernetes {
        config_path = "${path.module}/../.kubeconfig.yml"
    }
}

provider "zitadel" {
  domain           = "zitadel.scaleway.playground.dataminded.cloud"
  #Get a jwt token by creating a service account in ZITADEL console (https://zitadel.scaleway.playground.dataminded.cloud/ui/console) and create an associated key for it.
  jwt_profile_json = file("${path.module}/jwt_token.json")
}