terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
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