#==================================================
# SSL証明書
#==================================================
resource "aws_acm_certificate" "diglive" {
  domain_name               = aws_route53_record.diglive_type_a.name
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    # 再作成後に差し替えるため、SSL証明書再作成時のサービス影響を最小化
    create_before_destroy = true
  }
}

#==================================================
# SSL証明書の検証待機 (リソース非作成)
#==================================================
resource "aws_acm_certificate_validation" "diglive" {
  certificate_arn         = aws_acm_certificate.diglive.arn
  validation_record_fqdns = [aws_route53_record.diglive_type_cname.fqdn]
}
