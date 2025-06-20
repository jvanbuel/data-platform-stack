# Make sure it only gets created after cluster exists, which is why we depend on the datasource
provider "helm" {
  kubernetes {
    host = data.scaleway_k8s_cluster.cluster.kubeconfig[0].host
    token = data.scaleway_k8s_cluster.cluster.kubeconfig[0].token
    cluster_ca_certificate = base64decode(data.scaleway_k8s_cluster.cluster.kubeconfig[0].cluster_ca_certificate)
  }
}

data "scaleway_k8s_cluster" "cluster" {
  name = scaleway_k8s_cluster.k8s.name
}


# We install this here as a dependency for many modules in apps.
module "zitadel" {
  source = "../modules/zitadel"

  depends_on = [kubernetes_namespace.services, scaleway_k8s_pool.pool]
}

# We install this here as a dependency for many modules in apps.
module "traefik" {
  source = "../modules/traefik"

  depends_on = [kubernetes_namespace.traefik, scaleway_k8s_pool.pool]
}

