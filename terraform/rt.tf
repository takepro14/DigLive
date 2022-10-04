####################################################################################################
# RouteTable
####################################################################################################
#==================================================
# パブリック
#==================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dig-live.id
  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.dig-live.id
  destination_cidr_block = "0.0.0.0/0"
}

#==================================================
# プライベート
#==================================================
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.dig-live.id
  tags = {
    Name = "private_0"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.dig-live.id
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
