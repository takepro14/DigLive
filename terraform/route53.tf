#==================================================
# ホストゾーン
#==================================================
data "aws_route53_zone" "diglive" {
  name = "dig-live.com"
}

#==================================================
# DNSレコード
#==================================================
# ALB <=> ドメイン通信用
resource "aws_route53_record" "diglive_type_a" {
  zone_id = data.aws_route53_zone.diglive.zone_id
  name = data.aws_route53_zone.diglive.name
  type = "A"

  alias {
    name = aws_lb.diglive.dns_name
    zone_id = aws_lb.diglive.zone_id
    evaluate_target_health = true
  }
}

# SSL証明書の検証用
resource "aws_route53_record" "diglive_type_cname" {
  name = tolist(aws_acm_certificate.diglive.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.diglive.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.diglive.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.diglive.zone_id
  ttl = 60
}

output "domain_name" {
  value = aws_route53_record.diglive_type_a.name
}
