resource "aws_s3_bucket" "os" {
  bucket = "dp-stack-tf-os-${random_string.random.result}"
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}