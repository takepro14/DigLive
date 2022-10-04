####################################################################################################
# syntax
####################################################################################################

# curlコマンド
# curl ec25425024794.apnortheast1.compute.amazonaws.com

# variable "example_instance_type" {
#   default = "t3.micro"
# }

# # セキュリティグループ
# resource "aws_security_group" "example_ec2" {
#   name = "example-ec2"

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

# # EC2
# resource "aws_instance" "dig-live" {
#   ami = "ami-078296f82eb463377"
#   instance_type = var.example_instance_type
#   vpc_security_group_ids = [aws_security_group.example_ec2.id]

#   user_data = <<EOF
#     #! /bin/bash
#     yum install -y httpd
#     systemctl start httpd.service
#   EOF
# }

# output "example_instance_id" {
#   value = aws_instance.dig-live.public_dns
# }

#==================================================
# モジュール
#==================================================
# module "web_server" {
#   source = "./http_server"
#   instance_type = "t3.micro"
# }

# output "public_dns" {
#   value = module.web_server.public_dns
# }


#==================================================
# 組み込み関数
#==================================================
# resource "aws_instance" "dig-live" {
#   ami = "ami-078296f82eb463377"
#   instance_type = "t3.micro"
#   user_data = file("./user_data.sh")
# }
# # + user_data.shにapacheのインストールコマンドを用意
# #! /bin/bash
# yum install -y httpd
# systemctl start httpd.service

#==================================================
# プロバイダ
#==================================================
# provider "aws" {
#   region = "ap-northeast-1"
# }

#==================================================
# データソース
#==================================================
# data "aws_ami" "recent_amazon_linux_2" {
#   # 最新のAMIを取得
#   most_recent = true
#   owners = ["amazon"]
# }

# filter {
#   name = "name"
#   values = ["amzn2-ami-hvm-2.0.????????-x86_64_gp2"]
# }

# filter {
#   name = "state"
#   values = ["available"]
# }

# resource "aws_instance" "dig-live" {
#   ami = data.aws_ami.recent_amazon_linux_2.image_id
#   instance_type = "t3.micro"
# }

#==================================================
# 出力値
#==================================================
# resource "aws_instance" "dig-live" {
#   ami = "ami-078296f82eb463377"
#   instance_type = "t3.micro"
# }

# # 作成されたインスタンスのIDが出力される
# output "example_instance_id" {
#   value = aws_instance.dig-live.id
# }


#==================================================
# 変数
#==================================================
# variable "example_instance_type" {
#   default = "t3.micro"
# }

# resource "aws_instance" "dig-live" {
#   ami = "ami-078296f82eb463377"
#   instance_type = var.example_instance_type
# }

#==================================================
# ローカル変数
#==================================================
# locals {
#   example_instance_type = "t3.micro"
# }

# resource "aws_instance" "dig-live" {
#   ami = "ami-078296f82eb463377"
#   instance_type = local.example_instance_type
# }


