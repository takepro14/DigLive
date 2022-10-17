#==================================================
# ALB用
#==================================================
resource "aws_security_group_rule" "diglive_alb_rule1" {
  description       = "security group rule for diglive alb rule1"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}
resource "aws_security_group_rule" "diglive_alb_rule2" {
  description       = "security group rule for diglive alb rule2"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}
resource "aws_security_group_rule" "diglive_alb_rule3" {
  description       = "security group rule for diglive alb rule3"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}
resource "aws_security_group_rule" "diglive_alb_rule4" {
  description       = "security group rule for diglive alb rule4"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}
resource "aws_security_group_rule" "diglive_alb_rule5" {
  description       = "security group rule for diglive alb rule5"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}
resource "aws_security_group_rule" "diglive_alb_rule6" {
  description       = "security group rule for diglive alb rule6"
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_alb.id
}

#==================================================
# RDS用
#==================================================
resource "aws_security_group_rule" "diglive_rds_rule1" {
  description       = "security group rule for diglive rds rule1"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0", "0.0.0.0/16"]
  security_group_id = aws_security_group.diglive_rds.id
}
resource "aws_security_group_rule" "diglive_rds_rule2" {
  description       = "security group rule for diglive rds rule2"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_rds.id
}
resource "aws_security_group_rule" "diglive_rds_rule3" {
  description       = "security group rule for diglive rds rule3"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.diglive_rds.id
}

#==================================================
# ECS用
#==================================================
resource "aws_security_group_rule" "diglive_ecs_rule1" {
  description       = "security group rule for diglive ecs rule1"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule2" {
  description       = "security group rule for diglive ecs rule2"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule3" {
  description       = "security group rule for diglive ecs rule3"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule4" {
  description       = "security group rule for diglive ecs rule4"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule5" {
  description              = "security group rule for diglive ecs rule5"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.diglive_alb.id
  security_group_id        = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule6" {
  description       = "security group rule for diglive ecs rule6"
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
resource "aws_security_group_rule" "diglive_ecs_rule7" {
  description       = "security group rule for diglive ecs rule7"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.diglive_ecs.id
}
