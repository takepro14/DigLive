#==================================================
# ALB用
#==================================================
resource "aws_security_group" "diglive_alb" {
  description       = "security group for diglive alb"
  name = "diglive-alb"
  vpc_id = aws_vpc.diglive.id
}

#==================================================
# ECS用
#==================================================
resource "aws_security_group" "diglive_ecs" {
  description       = "security group for diglive ecs"
  name = "diglive-ecs"
  vpc_id = aws_vpc.diglive.id
}

#==================================================
# RDS用
#==================================================
resource "aws_security_group" "diglive_rds" {
  description       = "security group for diglive rds"
  name = "diglive-rds"
  vpc_id = aws_vpc.diglive.id
}
