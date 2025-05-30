
resource "exoscale_dbaas" "this" {
    name = "dp-exoscale-postgres"
    zone = local.zone
    type = "pg"
    plan= "startup-4"

    pg {
        version = "17"

        admin_username = "admin"
        admin_password = random_password.db_admin_password.result

        backup_schedule = "00:00" # Daily at midnight

        ip_filter = [ "0.0.0.0/0"]
    }
}

resource "random_password" "db_admin_password" {
  length  = 16
  special = false
}

output "password" {
  value = random_password.db_admin_password.result
  sensitive =true
}