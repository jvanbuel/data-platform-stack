resource "upcloud_managed_database_postgresql" "this" {
  name  = "dp-upcloud-postgres"
  plan  = "1x1xCPU-2GB-25GB"
  title = "postgres"
  zone  = local.zone
  properties {
    public_access  = true
    timezone       = "Europe/Helsinki"
    admin_username = "admin"
    admin_password = random_password.db_admin_password.result
  }
}

resource "random_password" "db_admin_password" {
  length  = 16
  special = false
}
