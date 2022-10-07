##################################################
# Application Load Balancer
##################################################

#=================================================
# ロードバランサー
#=================================================
resource "aws_lb" "diglive-alb" {
  name = "diglive-alb"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  # enable_deletion_protection = true

  # マルチAZ化するため
  subnets = [
    aws_subnet.diglive-sub-public-1a.id,
    aws_subnet.diglive-sub-public-1c.id
  ]

  access_logs {
    bucket = aws_s3_bucket.log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.https_redirect_sg.security_group_id
  ]
}

output "alb_dns_name" {
  value = aws_lb.diglive-alb.dns_name
}

#=================================================
# HTTPリスナー
#=================================================
resource "aws_lb_listener" "diglive-alb-listener-http" {
  load_balancer_arn = aws_lb.diglive-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code = "200"
    }
  }
}

#=================================================
# HTTPSリスナー
#=================================================
resource "aws_lb_listener" "diglive-alb-listener-https" {
  load_balancer_arn = aws_lb.diglive-alb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.diglive-acm-certificate.arn
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTPS』です"
      status_code = "200"
    }
  }
  depends_on = [
    aws_acm_certificate_validation.diglive
  ]
}

#=================================================
# HTTP to HTTPSリダイレクト
#=================================================
resource "aws_lb_listener" "diglive-alb-listener-redirect" {
  load_balancer_arn = aws_lb.diglive-alb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#=================================================
# ターゲットグループ
#=================================================
resource "aws_lb_target_group" "diglive-alb-tg" {
  name = "diglive"
  target_type = "ip"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 80
  protocol = "HTTP"
  deregistration_delay = 300

  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = 200
    port = "traffic-port"
    protocol = "HTTP"
  }

  depends_on = [
    aws_lb.diglive-alb
  ]
}

#=================================================
# リスナールール
#=================================================
resource "aws_lb_listener_rule" "diglive-alb-listener-rule" {
  listener_arn = aws_lb_listener.diglive-alb-listener-https.arn
  priority = 100

  # フォワード先のターゲットグループ
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.diglive-alb-tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
