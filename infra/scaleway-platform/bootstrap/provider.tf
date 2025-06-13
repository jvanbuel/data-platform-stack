terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }

  }

  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "nl-ams-1"
  region = "nl-ams"
  access_key = var.scaleway_key
  secret_key = var.scaleway_secret
}