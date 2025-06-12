resource "upcloud_router" "example" {
  name = "${var.prefix}-k8s-router"
}

# Create a network for your cluster
resource "upcloud_network" "example" {
  name = "${var.prefix}-k8s-net"
  zone = local.zone

  ip_network {
    address = var.ip_network_range
    dhcp    = true
    family  = "IPv4"
  }

  router = upcloud_router.example.id
}

moved {
  from = upcloud_kubernetes_cluster.example
  to   = upcloud_kubernetes_cluster.this
}

# Create a cluster
resource "upcloud_kubernetes_cluster" "this" {
  name                    = "${var.prefix}-k8s-cluster"
  network                 = upcloud_network.example.id
  control_plane_ip_filter = ["0.0.0.0/0"]
  zone                    = local.zone
}

resource "upcloud_kubernetes_node_group" "group" {
  name = "k8s-node-group"

  cluster    = upcloud_kubernetes_cluster.this.id
  node_count = 3

  plan = "6xCPU-16GB"

  anti_affinity = false

  labels = {
    managedBy = "terraform"
  }

  // If uncommented, Eeach node in this group will have this taint
  # taint {
  #   effect = "NoExecute"
  #   key    = "key"
  #   value  = "value"
  # }
  ssh_keys = []
}

data "upcloud_kubernetes_cluster" "this" {
  id = upcloud_kubernetes_cluster.this.id
}

resource "local_sensitive_file" "kubeconfig" {
  filename        = "${path.module}/.kubeconfig.yml"
  content         = data.upcloud_kubernetes_cluster.this.kubeconfig
  file_permission = "0600"
}

data "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}

resource "kubernetes_secret" "s3_credentials" {
  metadata {
    name      = "s3-credentials"
    namespace = data.kubernetes_namespace.services.metadata[0].name
  }

  data = {
    ACCESS_KEY_ID     = upcloud_managed_object_storage_user_access_key.this.access_key_id
    SECRET_ACCESS_KEY = upcloud_managed_object_storage_user_access_key.this.secret_access_key
    ENDPOINT          = "https://${tolist(upcloud_managed_object_storage.this.endpoint)[0].domain_name}"
    REGION            = local.zone
  }

  type = "Opaque"
}

resource "kubernetes_secret" "pg_credentials" {
  metadata {
    name      = "pg-credentials"
    namespace = data.kubernetes_namespace.services.metadata[0].name
  }

  data = {
    USERNAME = upcloud_managed_database_postgresql.this.service_username
    PASSWORD = upcloud_managed_database_postgresql.this.service_password
    HOST     = upcloud_managed_database_postgresql.this.service_host
    PORT     = upcloud_managed_database_postgresql.this.service_port
    URI      = upcloud_managed_database_postgresql.this.service_uri
  }

  type = "Opaque"
}
