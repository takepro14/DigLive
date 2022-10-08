#==================================================
# ALB用
#==================================================
module "diglive_sg_alb_http" {
  source = "./security_group"
  name = "diglive-sg-alb-http"
  vpc_id = aws_vpc.diglive.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "diglive_sg_alb_https" {
  source = "./security_group"
  name = "diglive-sg-alb-https"
  vpc_id = aws_vpc.diglive.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "diglive_sg_alb_redirect" {
  source = "./security_group"
  name = "diglive-sg-alb-redirect"
  vpc_id = aws_vpc.diglive.id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

#==================================================
# ECS用
#==================================================
module "diglive_sg_ecs_nginx" {
  source = "./security_group"
  name = "diglive-sg-ecs-nginx"
  vpc_id = aws_vpc.diglive.id
  port = 80
  cidr_blocks = [aws_vpc.diglive.cidr_block]
}

#==================================================
# RDS用
#==================================================
module "diglive_sg_rds_mysql" {
  source = "./security_group"
  name = "diglive-sg-rds-mysql"
  vpc_id = aws_vpc.diglive.id
  port = 3306
  cidr_blocks = [aws_vpc.diglive.cidr_block]
}
