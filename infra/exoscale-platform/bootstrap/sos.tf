resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "state" {
  bucket   = "dp-stack-tf-state-${random_string.random.result}"
}