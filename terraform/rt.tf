#==================================================
# ルートテーブル
#==================================================
resource "aws_route_table" "diglive_public" {
  vpc_id = aws_vpc.diglive.id
  tags = {
    Name = "diglive-public"
  }
}

resource "aws_route_table" "diglive_private_1a" {
  vpc_id = aws_vpc.diglive.id
  tags = {
    Name = "diglive-private_1a"
  }
}

resource "aws_route_table" "diglive_private_1c" {
  vpc_id = aws_vpc.diglive.id
  tags = {
    Name = "diglive-private_1c"
  }
}

#==================================================
# ルート
#==================================================
resource "aws_route" "diglive_public" {
  route_table_id = aws_route_table.diglive_public.id
  gateway_id = aws_internet_gateway.diglive.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route" "diglive_private_1a" {
#   route_table_id = aws_route_table.diglive_private_1a.id
#   nat_gateway_id = aws_nat_gateway.diglive_public_1a.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route" "diglive_private_1c" {
#   route_table_id = aws_route_table.diglive_private_1c.id
#   nat_gateway_id = aws_nat_gateway.diglive_public_1c.id
#   destination_cidr_block = "0.0.0.0/0"
# }
