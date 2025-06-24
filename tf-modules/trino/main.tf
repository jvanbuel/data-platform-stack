terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "trino" {
  chart = "${path.module}/../../../../argo/apps/500-trino"
  name  = "trino"
  namespace = "services"
  values = [
    <<EOF
trino:
  ingress:
    hosts:
      - host: "trino.${var.domain}"
        paths:
          - path: /
            pathType: Prefix
EOF
  ]
}