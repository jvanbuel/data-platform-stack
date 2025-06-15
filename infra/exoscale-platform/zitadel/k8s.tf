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

resource "random_uuid" "portal_api_key" {
}

resource "kubernetes_secret" "portal_secrets" {
  metadata {
    name      = "data-product-portal-secrets"
    namespace = "services"
  }

  data = {
    OIDC_CLIENT_ID     = var.portal_oidc_client_id
    OIDC_CLIENT_SECRET = var.portal_oidc_client_secret
    OIDC_AUDIENCE      = "324195878824837124"
    SMTP_USERNAME      = var.portal_smtp_username
    SMTP_PASSWORD      = var.portal_smtp_password
    PORTAL_API_KEY     = random_uuid.portal_api_key.result

  }
  type = "Opaque"
}

resource "kubernetes_config_map" "trino_frontend_oidc" {
  metadata {
    name      = "frontend"
    namespace = "services"
  }

  data = {
    "config.js" : <<EOF
      const config = (() => {
      return {
          API_BASE_URL: "https://portal.exoscale.playground.dataminded.cloud",
          OIDC_ENABLED: true,
          OIDC_CLIENT_ID: "${var.portal_oidc_client_id}",
          OIDC_CLIENT_SECRET: "${var.portal_oidc_client_secret}",
          OIDC_AUDIENCE: "324195878824837124", 
          OIDC_AUTHORITY: "https://zitadel.exoscale.playground.dataminded.cloud",
          OIDC_REDIRECT_URI: "https://portal.exoscale.playground.dataminded.cloud/",
          OIDC_POST_LOGOUT_REDIRECT_URI: "https://portal.exoscale.playground.dataminded.cloud/logout/",
          THEME_CONFIGURATION: "datamindedthemeconfig",
      }
  })();
  EOF
  }
}

