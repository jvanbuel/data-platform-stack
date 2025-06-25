terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "lakekeeper" {
  chart = "${path.module}/../../argo/apps/450-lakekeeper"
  name  = "lakekeeper"
  namespace = "services"
  wait       = false
  values = [
    <<EOF
lakekeeper:
  catalog:
    ingress:
      host: "lakekeeper.${var.domain}"
EOF
  ]
}