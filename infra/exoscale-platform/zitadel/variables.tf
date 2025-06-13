variable "portal_oidc_client_id" {
  description = "OIDC Client ID for the Data Product Portal"
  type        = string
}

variable "portal_oidc_client_secret" {
  description = "OIDC Client Secret for the Data Product Portal"
  type        = string
  sensitive   = true
}

variable "portal_smtp_username" {
  description = "SMTP Username for the Data Product Portal"
  type        = string

}

variable "portal_smtp_password" {
  description = "SMTP Password for the Data Product Portal"
  type        = string
  sensitive   = true
}