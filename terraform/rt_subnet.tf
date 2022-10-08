#==================================================
# サブネット × ルートテーブルの関連付け
#==================================================
resource "aws_route_table_association" "diglive_public_1a" {
  subnet_id = aws_subnet.diglive_public_1a.id
  route_table_id = aws_route_table.diglive_public.id
}

resource "aws_route_table_association" "diglive_private_1a" {
  subnet_id = aws_subnet.diglive_private_1a.id
  route_table_id = aws_route_table.diglive_private_1a.id
}

resource "aws_route_table_association" "diglive_public_1c" {
  subnet_id = aws_subnet.diglive_public_1c.id
  route_table_id = aws_route_table.diglive_public.id
}

resource "aws_route_table_association" "diglive_private_1c" {
  subnet_id = aws_subnet.diglive_private_1c.id
  route_table_id = aws_route_table.diglive_private_1c.id
}
