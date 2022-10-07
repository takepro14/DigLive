##################################################
# Route53
##################################################

#=================================================
# Host Zone
#=================================================
data "aws_route53_zone" "diglive-hostzone" {
  name = "diglive.com"
}

#=================================================
# Host Zone Record
#=================================================
# ALB => ドメイン可に
resource "aws_route53_record" "diglive-hostzone-record" {
  zone_id = data.aws_route53_zone.diglive-hostzone.zone_id
  name = data.aws_route53_zone.diglive-hostzone.name
  type = "A"

  alias {
    name = aws_lb.diglive-alb.dns_name
    zone_id = aws_lb.diglive-alb.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.diglive-hostzone-record.name
}
