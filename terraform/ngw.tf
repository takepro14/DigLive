# #==================================================
# # NATゲートウェイ
# #==================================================
# resource "aws_nat_gateway" "diglive_public_1a" {
#   allocation_id = aws_eip.diglive_public_1a.id
#   subnet_id = aws_subnet.diglive_public_1a.id
#   depends_on = [aws_internet_gateway.diglive]
#   tags = {
#     Name = "diglive-public-1a"
#   }
# }

# resource "aws_nat_gateway" "diglive_public_1c" {
#   allocation_id = aws_eip.diglive_public_1c.id
#   subnet_id = aws_subnet.diglive_public_1c.id
#   depends_on = [aws_internet_gateway.diglive]
#   tags = {
#     Name = "diglive-public-1c"
#   }
# }
