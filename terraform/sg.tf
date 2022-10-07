##################################################
# Security Group
##################################################

#=================================================
# ALB
#=================================================
module "http_sg" {
  source = "./security_group"
  name = "http-sg"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source = "./security_group"
  name = "https-sg"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_redirect_sg" {
  source = "./security_group"
  name = "http-redirect-sg"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

#=================================================
# ECS
#=================================================
module "nginx_sg" {
  source = "./security_group"
  name = "nginx-sg"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 80
  cidr_blocks = [aws_vpc.diglive-vpc.cidr_block]
}

#=================================================
# RDS
#=================================================
module "mysql_sg" {
  source = "./security_group"
  name = "mysql-sg"
  vpc_id = aws_vpc.diglive-vpc.id
  port = 3306
  cidr_blocks = [aws_vpc.diglive-vpc.cidr_block]
}
