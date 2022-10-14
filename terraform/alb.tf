#==================================================
# ロードバランサー
#==================================================
resource "aws_lb" "diglive" {
  name               = "diglive"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  # enable_deletion_protection = true

  # マルチAZ化するため
  subnets = [
    aws_subnet.diglive_public_1a.id,
    aws_subnet.diglive_public_1c.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.diglive_log.id
    enabled = true
  }

  security_groups = [
    module.diglive_sg_alb_http.security_group_id,
    module.diglive_sg_alb_https.security_group_id,
    module.diglive_sg_alb_redirect.security_group_id
  ]

  tags = {
    Name = "diglive"
  }
}

output "alb_dns_name" {
  value = aws_lb.diglive.dns_name
}

#==================================================
# HTTPリスナー
#==================================================
resource "aws_lb_listener" "diglive_http" {
  load_balancer_arn = aws_lb.diglive.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# default_action {
#   type = "fixed-response"

#   fixed_response {
#     content_type = "text/plain"
#     message_body = "これは『HTTP』です"
#     status_code = "200"
#   }
# }

#==================================================
# HTTPSリスナー
#==================================================
resource "aws_lb_listener" "diglive_https" {
  load_balancer_arn = aws_lb.diglive.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.diglive.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.diglive_front.arn
    type             = "forward"
  }

  depends_on = [
    aws_acm_certificate_validation.diglive
  ]
}

# # HTTPSリスナーにルールをアタッチ
# resource "aws_lb_listener_rule" "diglive" {
#   listener_arn = aws_lb_listener.diglive_https.arn
#   priority     = 100

#   # フォワード先のターゲットグループ
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.diglive_front.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }


# resource "aws_lb_listener" "gadget-api-listener" {
#   load_balancer_arn = aws_lb.gadget-alb.arn
#   port              = "3000"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.gadget-acm.arn

#   default_action {
#     target_group_arn = aws_lb_target_group.gadget-alb-api-tg.arn
#     type             = "forward"
#   }
# }

#==================================================
# ターゲットグループ
#==================================================
resource "aws_lb_target_group" "diglive_front" {
  name        = "diglive-front"
  target_type = "ip"
  vpc_id      = aws_vpc.diglive.id
  port        = 80
  protocol    = "HTTP"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 120
    interval            = 150
    matcher             = 200
    port                = 80
    protocol            = "HTTP"
  }

  depends_on = [
    aws_lb.diglive
  ]
}

