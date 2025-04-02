# Create all subnets
resource "aws_subnet" "lab_public_subnet_a" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_subnet" "lab_private_subnet_a" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.2.0/23"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet"
  }
}

# Create route tables
resource "aws_route_table" "lab_public_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
resource "aws_route_table" "lab_private_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "Private Route Table"
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
