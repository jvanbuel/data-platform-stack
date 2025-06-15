locals {
  domain_name = "playground.dataminded.cloud"
  zone_id     = data.aws_route53_zone.this.zone_id
}
