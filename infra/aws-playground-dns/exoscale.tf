locals {
  exoscale_ip = "194.182.162.23"
}

# *.exoscale.playground.dataminded.cloud
resource "aws_route53_record" "exoscale_wildcard" {
  zone_id = local.zone_id
  type    = "A"
  ttl     = 300
  name    = "*.exoscale.${local.domain_name}"
  records = [local.exoscale_ip]
}

