##################################################
# Elastic IP
##################################################

#=================================================
# Availability-Zone 1a
#=================================================
# resource "aws_eip" "diglive-eip-public-1a" {
#   vpc = true
#   depends_on = [aws_internet_gateway.diglive-igw]
# }

#=================================================
# Availability-Zone 1c
#=================================================
# resource "aws_eip" "diglive-eip-public-1c" {
#   vpc = true
#   depends_on = [aws_internet_gateway.diglive-igw]
# }
