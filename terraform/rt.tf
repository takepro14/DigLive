##################################################
# RouteTable / Route
##################################################

#=================================================
# Common
#=================================================
resource "aws_route_table" "diglive-rt-public" {
  vpc_id = aws_vpc.diglive-vpc.id
  tags = {
    Name = "diglive-rt-public"
  }
}

resource "aws_route" "diglive-route-public" {
  route_table_id = aws_route_table.diglive-rt-public.id
  gateway_id = aws_internet_gateway.diglive-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#=================================================
# Availability-Zone 1a
#=================================================
resource "aws_route_table" "diglive-rt-private-1a" {
  vpc_id = aws_vpc.diglive-vpc.id
  tags = {
    Name = "diglive-rt-private-1a"
  }
}

# resource "aws_route" "diglive-route-private-1a" {
#   route_table_id = aws_route_table.diglive-rt-private-1a.id
#   nat_gateway_id = aws_nat_gateway.diglive-ngw-public-1a.id
#   destination_cidr_block = "0.0.0.0/0"
# }

#=================================================
# Availability-Zone 1c
#=================================================
resource "aws_route_table" "diglive-rt-private-1c" {
  vpc_id = aws_vpc.diglive-vpc.id
  tags = {
    Name = "diglive-rt-private-1c"
  }
}

# resource "aws_route" "diglive-route-private-1c" {
#   route_table_id = aws_route_table.diglive-rt-private-1c.id
#   nat_gateway_id = aws_nat_gateway.diglive-ngw-public-1c.id
#   destination_cidr_block = "0.0.0.0/0"
# }
