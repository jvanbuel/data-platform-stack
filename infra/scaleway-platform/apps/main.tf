locals {
  domain = "scaleway.playground.dataminded.cloud"
}

module "zitadel-apps" {
  source = "../../../tf-modules/zitadel-applications"
  domain = local.domain
}

module "trino" {
  source = "../../../tf-modules/trino"
  depends_on = [module.zitadel-apps]
  domain = local.domain
}

module "opa" {
  source = "../../../tf-modules/opa"
  depends_on = [module.zitadel-apps]
}

module "lakekeeper" {
  source = "../../../tf-modules/lakekeeper"
  depends_on = [module.zitadel-apps]
  domain = local.domain
}

module "airflow" {
  source = "../../../tf-modules/airflow"
  depends_on = [module.zitadel-apps]
  domain = local.domain
}