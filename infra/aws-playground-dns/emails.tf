# Transactional email domain on Scaleway
resource "scaleway_tem_domain" "this" {
  name       = local.domain_name
  accept_tos = true
  region     = "fr-par" # TEM not available yet in ams (2025-06-15)
}

# Following block gave HTTP 501 error
resource "scaleway_tem_domain_validation" "this" {
  domain_id = scaleway_tem_domain.this.id
  timeout   = 300      # seconds
  region    = "fr-par" # TEM not available yet in ams (2025-06-15)
  depends_on = [
    aws_route53_record.spf,
    aws_route53_record.dkim_0001,
    aws_route53_record.mx_record,
    aws_route53_record.dmarc_record
  ]
}

# All below are DNS records on AWS route 53
# SPF
resource "aws_route53_record" "spf" {
  zone_id = local.zone_id
  type    = "TXT"
  ttl     = 300
  name    = local.domain_name
  records = ["v=spf1 ${scaleway_tem_domain.this.spf_config} -all"]
}

# TXT
resource "aws_route53_record" "dkim_0001" {
  zone_id = local.zone_id
  type    = "TXT"
  ttl     = 300
  name    = "${scaleway_tem_domain.this.project_id}._domainkey"
  records = [join("\" \"", compact(regexall(".{1,220}", scaleway_tem_domain.this.dkim_config)))] # DKIM record is over 255 characters so we need to chunk it
}

# MX
resource "aws_route53_record" "mx_record" {
  zone_id = local.zone_id
  type    = "MX"
  ttl     = 300
  name    = local.domain_name
  records = ["10 blackhole.scw-tem.cloud."] # 10 is priority
}

# DMARC
resource "aws_route53_record" "dmarc_record" {
  zone_id = local.zone_id
  type    = "TXT"
  ttl     = 300
  name    = "_dmarc"
  records = [scaleway_tem_domain.this.dmarc_config]
}


