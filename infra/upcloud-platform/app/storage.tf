resource "upcloud_managed_object_storage" "this" {
  name              = "dp-stack-tf-os-${random_string.random.result}"
  region            = "europe-1"
  configured_status = "started"

  network {
    family = "IPv4"
    name   = "object-storage-net"
    type   = "public"
  }
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}
