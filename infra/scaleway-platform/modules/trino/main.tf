terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "trino" {
  chart = "${path.module}/../../../argo/apps/500-trino"
  name  = "trino-wrapper"
  namespace = "services"
}