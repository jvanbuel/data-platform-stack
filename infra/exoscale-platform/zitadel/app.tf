locals {
  org_id = "324185190329025154"
}
resource "zitadel_project" "trino" {
  name   = "trino"
  org_id = local.org_id
}



resource "zitadel_application_oidc" "trino" {
  project_id = zitadel_project.trino.id
  org_id     = local.org_id

  name                      = "trino"
  redirect_uris             = ["https://trino.exoscale.playground.dataminded.cloud/oauth2/callback"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}


resource "zitadel_application_oidc" "portal" {
  project_id = zitadel_project.trino.id
  org_id     = local.org_id

  name                      = "portal"
  redirect_uris             = ["https://portal.exoscale.playground.dataminded.cloud/"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}

