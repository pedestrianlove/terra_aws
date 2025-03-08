# Create all subnets
resource "aws_subnet" "lab_public_subnet_a" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lab-subnet-public1-us-east-1a"
  }
}
resource "aws_subnet" "lab_private_subnet_a" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "lab-subnet-private1-us-east-1a"
  }
}
resource "aws_subnet" "lab_public_subnet_b" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "lab-subnet-public2-us-east-1b"
  }
}
resource "aws_subnet" "lab_private_subnet_b" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "lab-subnet-private2-us-east-1b"
  }
}

# Create an NAT Gateway in zone a public subnet
resource "aws_eip" "lab_eip" {
}
resource "aws_nat_gateway" "lab_nat" {
  allocation_id = aws_eip.lab_eip.allocation_id
  subnet_id     = aws_subnet.lab_public_subnet_a.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.lab_igw]
}

# Create route tables
resource "aws_route_table" "lab_public_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}
resource "aws_route_table" "lab_private_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab_nat.id
  }

  tags = {
    Name = "Private Subnet Route Table"
  }
}

# Add route tables to subnets
resource "aws_route_table_association" "lab_add_rtb_public_a" {
  subnet_id      = aws_subnet.lab_public_subnet_a.id
  route_table_id = aws_route_table.lab_public_route_table.id
}
resource "aws_route_table_association" "lab_add_rtb_private_a" {
  subnet_id      = aws_subnet.lab_private_subnet_a.id
  route_table_id = aws_route_table.lab_private_route_table.id
}
resource "aws_route_table_association" "lab_add_rtb_public_b" {
  subnet_id      = aws_subnet.lab_public_subnet_b.id
  route_table_id = aws_route_table.lab_public_route_table.id
}
resource "aws_route_table_association" "lab_add_rtb_private_b" {
  subnet_id      = aws_subnet.lab_private_subnet_b.id
  route_table_id = aws_route_table.lab_private_route_table.id
}
