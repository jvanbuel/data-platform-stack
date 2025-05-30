
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
    username = exoscale_dbaas.this.pg.admin_username
    password = exoscale_dbaas.this.pg.admin_password
    host     = data.exoscale_database_uri.this.host
    port     = data.exoscale_database_uri.this.port
    uri      = data.exoscale_database_uri.this.uri
  }

  type = "Opaque"
}


resource "kubernetes_secret" "sos_credentials" {
  metadata {
    name      = "sos-credentials"
    namespace = "services"
  }

  data = {
    access_key_id     = exoscale_iam_api_key.sos.key
    secret_access_key = exoscale_iam_api_key.sos.secret
  }

  type = "Opaque"
  
}