terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "opa" {
  chart = "${path.module}/../../argo/apps/550-opa"
  name  = "opa"
  namespace = "opa"
  values = [
    <<EOF
opa-kube-mgmt:
  image:
    repository: nilli9990/opa-lakekeeper
    tag: latest
    pullPolicy: Always
EOF
  ]
}