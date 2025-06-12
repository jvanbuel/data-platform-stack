output "db_password" {
  value     = random_password.db_admin_password.result
  sensitive = true
}
