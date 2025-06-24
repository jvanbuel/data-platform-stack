resource "zitadel_org" "dataminded" {
  name = "dataminded"
}

resource "zitadel_project" "trino" {
  name   = "trino"
  org_id = zitadel_org.dataminded.id
  depends_on = [zitadel_org.dataminded]
}

resource "zitadel_project" "lakekeeper" {
  name   = "lakekeeper"
  org_id = zitadel_org.dataminded.id

  depends_on = [zitadel_org.dataminded]
}

resource "zitadel_application_oidc" "trino" {
  project_id = zitadel_project.trino.id
  org_id     = zitadel_org.dataminded.id

  name                      = "trino"
  redirect_uris             = ["https://trino.scaleway.playground.dataminded.cloud/oauth2/callback"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}

resource "zitadel_application_oidc" "lakekeeper" {
  project_id = zitadel_project.lakekeeper.id
  org_id     = zitadel_org.dataminded.id

  name                      = "lakekeeper"
  redirect_uris             = ["https://lakekeeper.scaleway.playground.dataminded.cloud/oauth2/callback"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}
