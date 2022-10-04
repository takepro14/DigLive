####################################################################################################
# Route53
####################################################################################################
#==================================================
# ホストゾーンの参照
#==================================================
data "aws_route53_zone" "dig-live" {
  name = "dig-live.com"
}

#==================================================
# DNSレコード(ドメイン=>ALBへのアクセス可に)
#==================================================
resource "aws_route53_record" "dig-live_host-zone-record" {
  zone_id = data.aws_route53_zone.dig-live.zone_id
  name = data.aws_route53_zone.dig-live.name
  type = "A"

  alias {
    name = aws_lb.dig-live.dns_name
    zone_id = aws_lb.dig-live.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.dig-live_host-zone-record.name
}
