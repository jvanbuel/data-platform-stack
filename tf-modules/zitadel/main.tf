terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "zitadel" {
  chart = "${path.module}/../../argo/apps/600-zitadel"
  name  = "zitadel"
  namespace = "services"
  values = [
<<EOF
zitadel:
  zitadel:
    configmapConfig:
      ExternalDomain: "zitadel.${var.domain}"
  ingress:
    hosts:
      - host: "zitadel.${var.domain}"
        paths:
          - path: /
            pathType: Prefix
EOF
]
}