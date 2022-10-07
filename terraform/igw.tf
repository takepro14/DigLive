##################################################
# Internet Gateway
##################################################
resource "aws_internet_gateway" "diglive-igw" {
  vpc_id = aws_vpc.diglive-vpc.id

  tags = {
    Name = "diglive-igw"
  }
}
