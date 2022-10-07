##################################################
# Subnet
##################################################
#=================================================
# Availability-Zone 1
#=================================================
resource "aws_subnet" "diglive-sub-public-1a" {
  vpc_id = aws_vpc.diglive-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "diglive-sub-public-1a"
  }
}

resource "aws_subnet" "diglive-sub-private-1a" {
  vpc_id = aws_vpc.diglive-vpc.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "diglive-sub-private-1a"
  }
}

#=================================================
# Availability-Zone 2
#=================================================
resource "aws_subnet" "diglive-sub-public-1c" {
  vpc_id = aws_vpc.diglive-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "diglive-sub-public-1c"
  }
}

resource "aws_subnet" "diglive-sub-private-1a" {
  vpc_id = aws_vpc.diglive-vpc.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "diglive-sub-private-1a"
  }
}
