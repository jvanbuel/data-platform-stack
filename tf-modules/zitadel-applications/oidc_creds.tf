data "zitadel_org" "default" {
  id = "325930134207005293" # TODO replace with your default ziteadel org ID
}

resource "zitadel_project" "trino" {
  name   = "trino"
  org_id = data.zitadel_org.default.id
}

resource "zitadel_project" "lakekeeper" {
  name   = "lakekeeper"
  org_id = data.zitadel_org.default.id
}

resource "zitadel_application_oidc" "trino" {
  project_id = zitadel_project.trino.id
  org_id = data.zitadel_org.default.id

  name                      = "trino"
  redirect_uris             = ["https://trino.${var.domain}/oauth2/callback"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}

resource "zitadel_machine_user" "trino-opa" {
  org_id      = data.zitadel_org.default.id
  user_name   = "trino-opa"
  name        = "trino-opa"
  description = "a machine user for opa to access Zitadle"
  with_secret = true
}

resource "zitadel_application_oidc" "lakekeeper" {
  project_id = zitadel_project.lakekeeper.id
  org_id = data.zitadel_org.default.id

  name                      = "lakekeeper"
  redirect_uris             = ["https://lakekeeper.${var.domain}/oauth2/callback"]
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  post_logout_redirect_uris = ["http://localhost"]
  dev_mode                  = true
  auth_method_type          = "OIDC_AUTH_METHOD_TYPE_BASIC"
}
