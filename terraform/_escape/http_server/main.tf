# # 入力パラメータ
# variable "instance_type" {}

# # EC2
# resource "aws_instance" "default" {
#   ami = "ami-078296f82eb463377"
#   vpc_security_group_ids = [aws_security_group.default.id]
#   instance_type = var.instance_type

#   user_data = <<EOF
#     #! /bin/bash
#     yum install -y httpd
#     systemctl start httpd.service
#   EOF
# }

# # セキュリティグループ
# resource "aws_security_group" "default" {
#   name = "ec2"

#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# output "public_dns" {
#   value = aws_instance.default.public_dns
# }



