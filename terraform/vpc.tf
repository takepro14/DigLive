##################################################
# Virtual Private Cloud
##################################################
resource "aws_vpc" "diglive-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "diglive-vpc"
  }
}