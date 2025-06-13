resource "exoscale_iam_role" "sos" {
  name        = "dp-exoscale-sos"
  description = "Role for the SOS service"
  editable    = true

  policy = {
    default_service_strategy = "deny"
    services = {
      sos = {
        type = "allow"
      }
    }
  }

}

resource "exoscale_iam_api_key" "sos" {
  name    = "sos-api-key"
  role_id = exoscale_iam_role.sos.id
}