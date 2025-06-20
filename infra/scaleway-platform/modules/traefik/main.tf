terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "traefik" {
  chart = "${path.module}/../../../argo/apps/100-traefik"
  name  = "traefik-wrapper"
  namespace = "traefik"
}