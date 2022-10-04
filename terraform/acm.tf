####################################################################################################
# AWS Certificate Manager
####################################################################################################
#==================================================
# SSL証明書の定義
#==================================================
resource "aws_acm_certificate" "dig-live" {
  domain_name = aws_route53_record.dig-live_host-zone-record.name
  validation_method = "DNS"

  lifecycle {
    # 再作成後に差し替えるため、SSL証明書再作成時のサービス影響を最小化
    create_before_destroy = true
  }
}

#==================================================
# SSL証明書の検証用レコード定義
#==================================================
resource "aws_route53_record" "dig-live_validation-record" {
  name = tolist(aws_acm_certificate.dig-live.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.dig-live.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.dig-live.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.dig-live.zone_id
  ttl = 60
}

#==================================================
# SSL証明書の検証完了まで待機
#==================================================
# リソースを作るわけではない
resource "aws_acm_certificate_validation" "dig-live" {
  certificate_arn = aws_acm_certificate.dig-live.arn
  validation_record_fqdns = [aws_route53_record.dig-live_validation-record.fqdn]
}
