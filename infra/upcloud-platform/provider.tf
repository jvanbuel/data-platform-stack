terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "5.22.1"
    }
  }
}

provider "upcloud" {
}
