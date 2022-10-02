####################################################################################################
# iam
####################################################################################################
# module "describe_regions_for_ec2" {
#   source = "./iam_role"
#   name = "describe-regions-for-ec2"
#   identifier = "ec2.amazonaws.com"
#   policy = data.aws_iam_policy_document.allow_describe_regions.json
# }

####################################################################################################
# VPC
####################################################################################################
#==================================================
# VPC
#==================================================
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

#==================================================
# サブネット
#==================================================
resource "aws_subnet" "public_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_0"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1"
  }
}

resource "aws_subnet" "private_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_0"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1"
  }
}

#==================================================
# インターネットゲートウェイ
#==================================================
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example"
  }
}

#==================================================
# ルートテーブル
#==================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "private_0"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "private_1"
  }
}

resource "aws_route" "private_0" {
  route_table_id = aws_route_table.private_0.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id = aws_route_table.private_1.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

#==================================================
# ルート×サブネットの関連付け
#==================================================
resource "aws_route_table_association" "public_0" {
  subnet_id = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_0" {
  subnet_id = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

#==================================================
# EIP/NAT(プライベートサブネット用)
#==================================================
resource "aws_eip" "nat_gateway_0" {
  vpc = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id = aws_subnet.public_0.id
  depends_on = [aws_internet_gateway.example]
  tags = {
    Name = "nat_gateway_0"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id = aws_subnet.public_1.id
  depends_on = [aws_internet_gateway.example]
  tags = {
    Name = "nat_gateway_1"
  }
}

#==================================================
# セキュリティグループ
#==================================================
resource "aws_security_group" "example" {
  name = "example"
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example"
  }
}

resource "aws_security_group_rule" "ingress_example" {
  type = "ingress"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "egress_example" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

####################################################################################################
# ALB
####################################################################################################
resource "aws_lb" "example" {
  name = "example"
  load_balancer_type = "application"
  # インターネット向け
  internal = false
  idle_timeout = 60
  # 削除保護
  enable_deletion_protection = true

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





# ####################################################################################################
# # S3
# ####################################################################################################
# #==================================================
# # プライベートバケット
# #==================================================
# # バケット本体
# resource "aws_s3_bucket" "private" {
#   bucket = "private-haribotake-bucket"
#   force_destroy = true
# }

# # バージョニング
# resource "aws_s3_bucket_versioning" "private" {
#   bucket = aws_s3_bucket.private.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # オブジェクトの暗号化
# resource "aws_s3_bucket_server_side_encryption_configuration" "private" {
#   bucket = aws_s3_bucket.private.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# # パブリックアクセスのブロック
# resource "aws_s3_bucket_public_access_block" "private" {
#   bucket = aws_s3_bucket.private.id
#   block_public_acls = true
#   block_public_policy = true
#   ignore_public_acls = true
#   restrict_public_buckets = true
# }

# #==================================================
# # パブリックバケット
# #==================================================
# # バケット本体
# resource "aws_s3_bucket" "public" {
#   bucket = "public-haribotake-bucket"
#   force_destroy = true
# }

# # CORS設定
# resource "aws_s3_bucket_cors_configuration" "public" {
#   bucket = aws_s3_bucket.public.id

#   cors_rule {
#     allowed_origins = ["https://example.com"]
#     allowed_methods = ["GET"]
#     allowed_headers = ["*"]
#     max_age_seconds = 3000
#   }
# }

# # ACL設定
# resource "aws_s3_bucket_acl" "public" {
#   bucket = aws_s3_bucket.public.id

#   acl = "public-read"
# }


# #==================================================
# # ログバケット
# #==================================================
# # バケット本体
# resource "aws_s3_bucket" "log" {
#   bucket = "log-haribotake-bucket"
#   force_destroy = true
# }

# # ライフサイクルルール
# resource "aws_s3_bucket_lifecycle_configuration" "log" {
#   bucket = aws_s3_bucket.log.id

#   rule {
#     id = "log"

#     expiration {
#       days = 180
#     }
#     status = "Enabled"
#   }
# }

# # バケットポリシー
# resource "aws_s3_bucket_policy" "log" {
#   bucket = aws_s3_bucket.log.id
#   policy = data.aws_iam_policy_document.log.json
# }

# data "aws_iam_policy_document" "log" {
#   statement {
#     effect = "Allow"
#     actions = ["s3:PutObject"]
#     resources = ["arn:aws:s3:::${aws_s3_bucket.log.id}/*"]

#     principals {
#       type = "AWS"
#       identifiers = ["454636438913"]
#     }
#   }
# }


####################################################################################################
# アクティブold
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
# resource "aws_instance" "example" {
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
#   value = aws_instance.example.public_dns
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
# resource "aws_instance" "example" {
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

# resource "aws_instance" "example" {
#   ami = data.aws_ami.recent_amazon_linux_2.image_id
#   instance_type = "t3.micro"
# }

#==================================================
# 出力値
#==================================================
# resource "aws_instance" "example" {
#   ami = "ami-078296f82eb463377"
#   instance_type = "t3.micro"
# }

# # 作成されたインスタンスのIDが出力される
# output "example_instance_id" {
#   value = aws_instance.example.id
# }


#==================================================
# 変数
#==================================================
# variable "example_instance_type" {
#   default = "t3.micro"
# }

# resource "aws_instance" "example" {
#   ami = "ami-078296f82eb463377"
#   instance_type = var.example_instance_type
# }

#==================================================
# ローカル変数
#==================================================
# locals {
#   example_instance_type = "t3.micro"
# }

# resource "aws_instance" "example" {
#   ami = "ami-078296f82eb463377"
#   instance_type = local.example_instance_type
# }


