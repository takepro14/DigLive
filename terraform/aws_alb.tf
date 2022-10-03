####################################################################################################
# Application Load Balancer
####################################################################################################
#==================================================
# ロードバランサー
#==================================================
resource "aws_lb" "example" {
  name = "example"
  load_balancer_type = "application"
  # インターネット向け
  internal = false
  idle_timeout = 60
  # 削除保護
  # enable_deletion_protection = true

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
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
  value = aws_lb.example.dns_name
}

#==================================================
# HTTPリスナー
#==================================================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
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

# #==================================================
# # HTTPSリスナー
# #==================================================
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.example.arn
#   port = "443"
#   protocol = "HTTPS"
#   certificate_arn = aws_acm_certificate.example.arn
#   # 要確認
#   ssl_policy = "ELBSecurityPolicy-2022-10"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "これは『HTTPS』です"
#       status_code = "200"
#     }
#   }
# }

# #==================================================
# # HTTP to HTTPSリダイレクト
# #==================================================
# resource "aws_lb_listener" "redirect_http_to_https" {
#   load_balancer_arn = aws_lb.example.arn
#   port = "8080"
#   protocol = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port = "443"
#       protocol = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# #==================================================
# ターゲットグループ
# #==================================================
# resource "aws_lb_target_group" "example" {
#   name = "example"
#   # ターゲットの種類: ECS Fargateではip
#   target_type = "ip"
#   vpc_id = aws_vpc.example.id
#   port = 80
#   protocol = "HTTP"
#   deregistration_delay = 300

#   health_check {
#     path = "/"
#     healthy_threshold = 5
#     unhealthy_threshold = 2
#     timeout = 5
#     interval = 30
#     matcher = 200
#     port = "traffic-port"
#     protocol = "HTTP"
#   }

#   depends_on = [
#     aws_lb.example
#   ]
# }

# #==================================================
# # リスナールール
# #==================================================
# resource "aws_lb_listener_rule" "example" {
#   listener_arn = aws_lb_listener.https.arn
#   priority = 100

#   # フォワード先のターゲットグループ
#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.example.arn
#   }

#   condition {
#     field = "path-pattern"
#     values = ["/*"]
#   }
# }

# #==================================================
# # セキュリティグループ (ALB)
# #==================================================
# module "http_sg" {
#   source = "./security_group"
#   name = "http-sg"
#   vpc_id = aws_vpc.example.id
#   port = 80
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "https_sg" {
#   source = "./security_group"
#   name = "https-sg"
#   vpc_id = aws_vpc.example.id
#   port = 443
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "https_redirect_sg" {
#   source = "./security_group"
#   name = "http-redirect-sg"
#   vpc_id = aws_vpc.example.id
#   port = 8080
#   cidr_blocks = ["0.0.0.0/0"]
# }