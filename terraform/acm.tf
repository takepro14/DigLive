##################################################
# AWS Certificate Manager
##################################################

#=================================================
# SSL証明書
#=================================================
resource "aws_acm_certificate" "diglive-acm-certificate" {
  domain_name = aws_route53_record.diglive-hostzone-record.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    # 再作成後に差し替えるため、SSL証明書再作成時のサービス影響を最小化
    create_before_destroy = true
  }
}

#=================================================
# SSL証明書 検証レコード
#=================================================
resource "aws_route53_record" "diglive-acm-validation-record" {
  name = tolist(aws_acm_certificate.diglive-acm-certificate.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.diglive-acm-certificate.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.diglive-acm-certificate.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.diglive-hostzone.zone_id
  ttl = 60
}

#=================================================
# SSL証明書の検証完了まで待機
#=================================================
# リソースを作るわけではない
resource "aws_acm_certificate_validation" "diglive" {
  certificate_arn = aws_acm_certificate.diglive-acm-certificate.arn
  validation_record_fqdns = [aws_route53_record.diglive-acm-validation-record.fqdn]
}
