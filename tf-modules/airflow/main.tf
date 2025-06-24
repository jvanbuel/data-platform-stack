terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "opa" {
  chart = "${path.module}/../../../../argo/apps/200-airflow"
  name  = "airflow"
  namespace = "services"
  values = [
    <<EOF
airflow:
  ingress:
    host: "airflow.${var.domain}"
EOF
  ]
}