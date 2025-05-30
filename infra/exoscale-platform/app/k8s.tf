
data "exoscale_database_uri" "this" {
  name = exoscale_dbaas.this.name
  type = "pg"
  zone = local.zone
}


resource "kubernetes_secret" "pg_credentials" {
  metadata {
    name      = "pg-credentials"
    namespace = "default"
  }

  data = {
    username = exoscale_dbaas.this.pg.admin_username
    password = exoscale_dbaas.this.pg.admin_password
    host = data.exoscale_database_uri.this.host
    port = data.exoscale_database_uri.this.port
    uri = data.exoscale_database_uri.this.uri
  }

  type = "Opaque"
}