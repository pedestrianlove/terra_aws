data "aws_subnet" "lab_public_subnet_1" {
  tags = {
    Name = "IDE Public Subnet One"
  }
}

resource "aws_subnet" "lab_public_subnet_2" {
  vpc_id                  = data.aws_vpc.lab_vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "extraSubnetForRds"
  }
}

data "aws_route_table" "lab_public_route_table" {
  subnet_id = data.aws_subnet.lab_public_subnet_1.id
}

# resource "aws_route_table_association" "lab_public_subnet_1" {
#   subnet_id      = data.aws_subnet.lab_public_subnet_1.id
#   route_table_id = data.aws_route_table.lab_public_route_table.id
# }
resource "aws_route_table_association" "lab_public_subnet_2" {
  subnet_id      = aws_subnet.lab_public_subnet_2.id
  route_table_id = data.aws_route_table.lab_public_route_table.id
}
