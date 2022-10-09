#==================================================
# サブネット
#==================================================
resource "aws_subnet" "diglive_public_1a" {
  vpc_id                  = aws_vpc.diglive.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "diglive_public_1a"
  }
}

resource "aws_subnet" "diglive_private_1a" {
  vpc_id                  = aws_vpc.diglive.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "diglive_private_1a"
  }
}

resource "aws_subnet" "diglive_public_1c" {
  vpc_id                  = aws_vpc.diglive.id
  cidr_block              = "10.0.65.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "diglive_public_1c"
  }
}

resource "aws_subnet" "diglive_private_1c" {
  vpc_id                  = aws_vpc.diglive.id
  cidr_block              = "10.0.66.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "diglive_private_1c"
  }
}
