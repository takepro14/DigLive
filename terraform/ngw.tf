##################################################
# NAT Gateway
##################################################

#=================================================
# Availability-Zone 1a
#=================================================
# resource "aws_nat_gateway" "diglive-ngw-public-1a" {
#   allocation_id = aws_eip.diglive-eip-public-1a.id
#   subnet_id = aws_subnet.diglive-sub-public-1a.id
#   depends_on = [aws_internet_gateway.diglive-igw]
#   tags = {
#     Name = "diglive-ngw-public-1a"
#   }
# }

#=================================================
# Availability-Zone 1c
#=================================================
# resource "aws_nat_gateway" "diglive-ngw-public-1c" {
#   allocation_id = aws_eip.diglive-eip-public-1c.id
#   subnet_id = aws_subnet.diglive-sub-public-1c.id
#   depends_on = [aws_internet_gateway.diglive-igw]
#   tags = {
#     Name = "diglive-ngw-public-1c"
#   }
# }
