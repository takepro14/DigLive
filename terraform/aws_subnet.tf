####################################################################################################
# Subnet
####################################################################################################
#==================================================
# パブリック
#==================================================
resource "aws_subnet" "public_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_0"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1"
  }
}

#==================================================
# プライベート
#==================================================
resource "aws_subnet" "private_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_0"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1"
  }
}
