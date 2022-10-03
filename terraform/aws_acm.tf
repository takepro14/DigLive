####################################################################################################
# AWS Certificate Manager
####################################################################################################
# resource "aws_acm_certificate" "example" {
#   domain_name = aws_route53_record.example.name
#   subject_alternative_names = []
#   validation_method = "DNS"

#   lifecycle {
#     # 再作成後に差し替えるため、SSL証明書再作成時のサービス影響を最小化
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "example_certificate" {
#   name = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
#   type = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
#   records = [acm_certificate.example.domain_validation_options[0].resource_record_value]
#   zone_id = data.aws_route53_zone.example.id
#   ttl = 60
# }

# # SSL証明書の検証完了まで待機
# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn = aws_acm_certificate.example.arn
#   validation_record_fqdns = [aws_route53_record.example_certificate.fqdn]
# }
