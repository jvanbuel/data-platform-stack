
data "exoscale_database_uri" "my_database" {
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
    uri = data.exoscale_database_uri.my_database.uri
  }

  type = "Opaque"
}