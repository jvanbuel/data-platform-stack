
data "exoscale_database_uri" "this" {
  name = exoscale_dbaas.this.name
  type = "pg"
  zone = local.zone
}


resource "kubernetes_secret" "pg_credentials" {
  metadata {
    name      = "pg-credentials"
    namespace = "services"
  }

  data = {
    USERNAME = exoscale_dbaas.this.pg.admin_username
    PASSWORD = exoscale_dbaas.this.pg.admin_password
    HOST     = data.exoscale_database_uri.this.host
    PORT     = data.exoscale_database_uri.this.port
    URI      = data.exoscale_database_uri.this.uri
  }

  type = "Opaque"
}


resource "kubernetes_secret" "s3_credentials" {
  metadata {
    name      = "s3-credentials"
    namespace = "services"
  }

  data = {
    ACCESS_KEY_ID     = exoscale_iam_api_key.sos.key
    SECRET_ACCESS_KEY = exoscale_iam_api_key.sos.secret
    ENDPOINT          = "https://sos-${local.zone}.exo.io"
    REGION            = local.zone
  }

  type = "Opaque"

}