terraform {
  backend "s3" {
    bucket                      = "dp-stack-tf-state-qap29ly4pk5c5cut"
    key                         = "default.tfstate"
    region                      = "nl-ams"
    endpoint                    = "https://s3.nl-ams.scw.cloud"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}