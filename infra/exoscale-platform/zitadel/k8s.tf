resource "kubernetes_secret" "trino_oidc" {
  metadata {
    name      = "trino-oidc"
    namespace = "services"
  }

  data = {
    CLIENT_ID     = zitadel_application_oidc.trino.client_id
    CLIENT_SECRET = zitadel_application_oidc.trino.client_secret

  }

  type = "Opaque"
}


resource "kubernetes_secret" "portal_oidc" {
  metadata {
    name      = "portal-oidc"
    namespace = "services"
  }

  data = {
    CLIENT_ID     = zitadel_application_oidc.portal.client_id
    CLIENT_SECRET = zitadel_application_oidc.portal.client_secret
    ISSUER        = "https://zitadel.exoscale.robberthofman.com"
  }
  type = "Opaque"
}