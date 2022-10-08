#==================================================
# インターネットゲートウェイ
#==================================================
resource "aws_internet_gateway" "diglive" {
  vpc_id = aws_vpc.diglive.id

  tags = {
    Name = "diglive"
  }
}
