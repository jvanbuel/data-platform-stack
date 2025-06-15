variable "scaleway_access_key" {
  sensitive = false
  type      = string
}

variable "scaleway_secret_key" {
  sensitive = true
  type      = string
}

variable "scaleway_organization_id" {
  sensitive = true
  type      = string
}

variable "scaleway_project_id" {
  sensitive = true
  type      = string
}
