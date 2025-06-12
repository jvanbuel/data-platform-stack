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

# Create a cluster
resource "upcloud_kubernetes_cluster" "example" {
  name    = "${var.prefix}-k8s-cluster"
  network = upcloud_network.example.id
  control_plane_ip_filter = ["0.0.0.0/0"]
  zone    = local.zone
}

resource "upcloud_kubernetes_node_group" "group" {
  name = "k8s-node-group"

  cluster    = upcloud_kubernetes_cluster.example.id
  node_count = 3

  plan       = "2xCPU-4GB"

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
