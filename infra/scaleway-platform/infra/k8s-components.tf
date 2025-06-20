provider "helm" {
  kubernetes {
    config_path = "${path.module}/../.kubeconfig.yml"
  }
}

# We install this here as a dependency for many modules in apps.
module "zitadel" {
  source = "../modules/zitadel"

  depends_on = [kubernetes_namespace.zitadel]
}

# We install this here as a dependency for many modules in apps.
module "traefik" {
  source = "../modules/traefik"

  depends_on = [kubernetes_namespace.traefik]
}

