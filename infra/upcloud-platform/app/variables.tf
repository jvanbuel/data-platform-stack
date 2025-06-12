variable "upcloud_username" {
  sensitive = false
  type      = string
}

variable "upcloud_password" {
  sensitive = true
  type      = string
}


variable "prefix" {
  type = string
  default = "eu-cloud-inno-days"
}

variable "ip_network_range" {
  default = "172.16.1.0/24"
  description = "CIDR range used by the cluster SDN network."
  type = string
}