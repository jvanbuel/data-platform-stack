terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "lakekeeper" {
  chart = "${path.module}/../../../argo/apps/450-lakekeeper"
  name  = "lakekeeper-wrapper"
  namespace = "services"
}