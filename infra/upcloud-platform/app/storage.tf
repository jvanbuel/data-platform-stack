resource "upcloud_managed_object_storage" "this" {
  name              = "dp-stack-tf-os-${random_string.random.result}"
  region            = "europe-2"
  configured_status = "started"

  network {
    family = "IPv4"
    name   = "object-storage-net"
    type   = "public"
  }
}

resource "upcloud_managed_object_storage_bucket" "example" {
  service_uuid = upcloud_managed_object_storage.this.id
  name         = "dp-stack-tf-os"
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}
