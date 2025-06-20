terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
resource "helm_release" "opa" {
  chart = "${path.module}/../../../argo/apps/200-airflow"
  name  = "airflow-wrapper"
  namespace = "services"
}