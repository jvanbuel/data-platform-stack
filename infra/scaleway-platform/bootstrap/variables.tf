variable "scaleway_key" {
  sensitive = false
  type      = string
}

variable "scaleway_secret" {
  sensitive = true
  type      = string

}