resource "scaleway_k8s_cluster" "k8s" {
  cni                         = "cilium"
  delete_additional_resources = false
  name                        = "scaleway-k8s-cluster"
  version                     = "1.32.3"
  private_network_id = scaleway_vpc_private_network.private_1.id
}

resource "scaleway_k8s_pool" "pool" {
  cluster_id = scaleway_k8s_cluster.k8s.id
  name       = "default-pool"
  node_type  = "DEV1-M"
  size       = 3
}

resource "local_sensitive_file" "kubeconfig" {
  filename        = "${path.module}/.kubeconfig.yml"
  content         = scaleway_k8s_cluster.k8s.kubeconfig[0].config_file
  file_permission = "0600"
}

provider "kubernetes" {
  config_path = local_sensitive_file.kubeconfig.filename
}


resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}

resource "kubernetes_secret" "s3_credentials" {
  metadata {
    name      = "s3-credentials"
    namespace = kubernetes_namespace.services.metadata[0].name
  }

  data = {
    ACCESS_KEY_ID     = upcloud_managed_object_storage_user_access_key.this.access_key_id
    SECRET_ACCESS_KEY = upcloud_managed_object_storage_user_access_key.this.secret_access_key
    ENDPOINT          = "https://s3.nl-ams.scw.cloud"
    REGION            = local.region
  }

  type = "Opaque"
}

resource "kubernetes_secret" "pg_credentials" {
  metadata {
    name      = "pg-credentials"
    namespace = kubernetes_namespace.services.metadata[0].name
  }

  data = {
    USERNAME = scale.this.service_username
    PASSWORD = scale.this.service_password
    HOST     = scale.this.service_host
    PORT     = scale.this.service_port
    URI      = scale.this.service_uri
  }

  type = "Opaque"
}
