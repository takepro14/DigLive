##################################################
# RouteTable * Subnet Association
##################################################

#=================================================
# Availability-Zone 1a
#=================================================
resource "aws_route_table_association" "diglive-rt-sub-public-1a" {
  subnet_id = aws_subnet.diglive-sub-public-1a.id
  route_table_id = aws_route_table.diglive-rt-public.id
}

resource "aws_route_table_association" "diglive-rt-sub-private-1a" {
  subnet_id = aws_subnet.diglive-sub-private-1a.id
  route_table_id = aws_route_table.diglive-rt-private-1a.id
}

#=================================================
# Availability-Zone 1c
#=================================================
resource "aws_route_table_association" "diglive-rt-sub-public-1c" {
  subnet_id = aws_subnet.diglive-sub-public-1c.id
  route_table_id = aws_route_table.diglive-rt-public.id
}

resource "aws_route_table_association" "diglive-rt-sub-private-1c" {
  subnet_id = aws_subnet.diglive-sub-private-1c.id
  route_table_id = aws_route_table.diglive-rt-private-1c.id
}
