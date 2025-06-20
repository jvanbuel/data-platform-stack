module "zitadel-apps" {
  source = "../modules/zitadel-applications"
  jwt_profile_file = var.zitadel_jwt_token
}

module "trino" {
  source = "../modules/trino"
}

module "traefik" {
  source = "../modules/traefik"
}

module "opa" {
  source = "../modules/opa"
}

module "lakekeeper" {
  source = "../modules/lakekeeper"
}
module "opa" {
  source = "../modules/airflow"
}