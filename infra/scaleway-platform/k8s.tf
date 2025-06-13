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
    ACCESS_KEY_ID     = scaleway_iam_api_key.main.access_key
    SECRET_ACCESS_KEY = scaleway_iam_api_key.main.secret_key
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
    USERNAME = scaleway_rdb_instance.main.user_name
    PASSWORD = scaleway_rdb_instance.main.password
    HOST     = scaleway_rdb_instance.main.endpoint_ip
    PORT     = scaleway_rdb_instance.main.load_balancer[0].port
    URI      = "jdb:postgresql://${scaleway_rdb_instance.main.endpoint_ip}"
  }
  type = "Opaque"
}


resource "kubernetes_secret" "database_secrets" {
  metadata {
    name = "lakekeeper-custom-secrets"
    namespace = "services"
  }
  data = {
    ICEBERG_REST__PG_HOST_R=scaleway_rdb_instance.main.endpoint_ip
    ICEBERG_REST__PG_HOST_W=scaleway_rdb_instance.main.endpoint_ip
    ICEBERG_REST__PG_PORT=scaleway_rdb_instance.main.load_balancer[0].port
    ICEBERG_REST__PG_PASSWORD=scaleway_rdb_instance.main.password
    ICEBERG_REST__PG_DATABASE=scaleway_rdb_database.main.name
    ICEBERG_REST__PG_USER=scaleway_rdb_instance.main.user_name
    ICEBERG_REST__SECRETS_BACKEND="Postgres"
    LAKEKEEPER__AUTHZ_BACKEND="allowall"
  }
  depends_on = [kubernetes_namespace.services]
}
