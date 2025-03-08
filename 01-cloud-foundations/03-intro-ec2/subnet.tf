# Recreate required subnets
data "aws_subnet" "lab_public_subnet_1" {
  tags = {
    Name = "PublicSubnet1"
  }
}

data "aws_subnet" "lab_public_subnet_2" {
  tags = {
    Name = "PublicSubnet2"
  }
}
