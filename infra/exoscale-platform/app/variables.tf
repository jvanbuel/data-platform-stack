variable "exoscale_key" {
  sensitive = false
  type      = string
}

variable "exoscale_secret" {
  sensitive = true
  type      = string

}

variable "bucket_name" {
  type = string
}