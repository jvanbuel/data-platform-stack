module "zitadel-apps" {
  source = "../../../tf-modules/zitadel-applications"
}

module "trino" {
  source = "../../../tf-modules/trino"
  depends_on = [module.zitadel-apps]
}

module "opa" {
  source = "../../../tf-modules/opa"
  depends_on = [module.zitadel-apps]
}

module "lakekeeper" {
  source = "../../../tf-modules/lakekeeper"
  depends_on = [module.zitadel-apps]
}

module "airflow" {
  source = "../../../tf-modules/airflow"
  depends_on = [module.zitadel-apps]
}