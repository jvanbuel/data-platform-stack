terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "zitadel" {
  chart = "${path.module}/../../../argo/apps/600-zitadel"
  name  = "zitadel-wrapper"
  namespace = "zitadel"
}