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
    bucket  = aws_s3_bucket.diglive_private_log.id
    enabled = true
  }

  security_groups = [
    aws_security_group.diglive_alb.id
  ]

  tags = {
    Name = "diglive"
  }
}

output "alb_dns_name" {
  value = aws_lb.diglive.dns_name
}

#==================================================
# リスナー
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

resource "aws_lb_listener" "diglive_https" {
  load_balancer_arn = aws_lb.diglive.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.diglive.arn

  default_action {
    target_group_arn = aws_lb_target_group.diglive_front.arn
    type             = "forward"
  }

  depends_on = [
    aws_acm_certificate_validation.diglive
  ]
}

resource "aws_lb_listener" "api_https" {
  load_balancer_arn = aws_lb.diglive.arn
  port              = "3000"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.diglive.arn

  default_action {
    target_group_arn = aws_lb_target_group.diglive_api.arn
    type             = "forward"
  }
}

#==================================================
# ターゲットグループ
#==================================================
resource "aws_lb_target_group" "diglive_front" {
  name                 = "diglive-front"
  target_type          = "ip"
  vpc_id               = aws_vpc.diglive.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 60

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

resource "aws_lb_target_group" "diglive_api" {
  name                 = "diglive-api"
  target_type          = "ip"
  vpc_id               = aws_vpc.diglive.id
  port                 = 3000
  protocol             = "HTTP"
  deregistration_delay = 60

  health_check {
    enabled             = true
    interval            = 60
    path                = "/api/v1/tasks"
    port                = 3000
    protocol            = "HTTP"
    matcher             = 200
    timeout             = 50
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

