# resource "upcloud_router" "this" {
#   name = "object-storage-router"
# }

# resource "upcloud_network" "this" {
#   name = "object-storage-net"
#   zone = local.zone

#   ip_network {
#     address = "172.16.2.0/24"
#     dhcp    = true
#     family  = "IPv4"
#   }

#   router = upcloud_router.this.id
# }

resource "upcloud_managed_object_storage" "this" {
  name              = "dp-stack-tf-state-${random_string.random.result}"
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
