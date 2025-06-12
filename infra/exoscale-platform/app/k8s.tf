
data "exoscale_database_uri" "this" {
  name = exoscale_dbaas.this.name
  type = "pg"
  zone = local.zone
}


resource "kubernetes_secret" "pg_credentials" {
  metadata {
    name      = "pg-credentials"
    namespace = kubernetes_namespace.services.metadata[0].name
  }

  data = {
    USERNAME = exoscale_dbaas.this.pg.admin_username
    PASSWORD = exoscale_dbaas.this.pg.admin_password
    HOST     = data.exoscale_database_uri.this.host
    PORT     = data.exoscale_database_uri.this.port
    URI      = data.exoscale_database_uri.this.uri
  }

  type = "Opaque"
}


resource "kubernetes_secret" "s3_credentials" {
  metadata {
    name      = "s3-credentials"
    namespace = kubernetes_namespace.services.metadata[0].name
  }

  data = {
    ACCESS_KEY_ID     = exoscale_iam_api_key.sos.key
    SECRET_ACCESS_KEY = exoscale_iam_api_key.sos.secret
    ENDPOINT          = "https://sos-${local.zone}.exo.io"
    REGION            = local.zone
  }

  type = "Opaque"

}


resource "kubernetes_annotations" "default_storage_class" {
  kind        = "StorageClass"
  api_version = "storage.k8s.io/v1"
  metadata {
    name = "exoscale-sbs"
  }

  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "true"
  }

}

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }

}

data "exoscale_database_uri" "dbaas" {
  name = exoscale_dbaas.this.name
  type = "pg"
  zone = local.zone
}

resource "kubernetes_secret" "database_secrets" {
  metadata {
    name = "lakekeeper-custom-secrets"
    namespace = "services"
  }
  data = {
    ICEBERG_REST__PG_HOST_R=data.exoscale_database_uri.dbaas.host
    ICEBERG_REST__PG_HOST_W=data.exoscale_database_uri.dbaas.host
    ICEBERG_REST__PG_PORT=data.exoscale_database_uri.dbaas.port
    ICEBERG_REST__PG_PASSWORD=data.exoscale_database_uri.dbaas.password
    ICEBERG_REST__PG_DATABASE="lakekeeper"
    ICEBERG_REST__PG_USER=data.exoscale_database_uri.dbaas.username
    ICEBERG_REST__SECRETS_BACKEND="Postgres"
    LAKEKEEPER__AUTHZ_BACKEND="allowall"
  }
  depends_on = [kubernetes_namespace.services]
}