resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "scaleway_object_bucket" "state" {
  name   = "dp-stack-tf-state-${random_string.random.result}"
  project_id = local.project_id
}