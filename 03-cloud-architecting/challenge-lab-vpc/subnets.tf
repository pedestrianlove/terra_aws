resource "aws_subnet" "lab_public_subnet_a" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_subnet" "lab_private_subnet_a" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet"
  }
}

# Create an NAT Gateway in zone a public subnet
resource "aws_eip" "lab_eip" {
}
resource "aws_nat_gateway" "lab_nat" {
  allocation_id = aws_eip.lab_eip.allocation_id
  subnet_id     = aws_subnet.lab_public_subnet_a.id

  tags = {
    Name = "Lab NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.lab_igw]
}

# Create the route tables
# Create route tables
resource "aws_route_table" "lab_public_route_table" {
  vpc_id = data.aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
resource "aws_route_table" "lab_private_route_table" {
  vpc_id = data.aws_vpc.lab_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab_nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Assign the route table to the subnet
resource "aws_route_table_association" "lab_public_subnet_a_rtb" {
  subnet_id      = aws_subnet.lab_public_subnet_a.id
  route_table_id = aws_route_table.lab_public_route_table.id
}
resource "aws_route_table_association" "lab_private_subnet_a_rtb" {
  subnet_id      = aws_subnet.lab_private_subnet_a.id
  route_table_id = aws_route_table.lab_private_route_table.id
}

# Add a network ACL to the VPC
resource "aws_network_acl" "lab_network_acl" {
  vpc_id = data.aws_vpc.lab_vpc.id

  subnet_ids = [
    aws_subnet.lab_private_subnet_a.id
  ]

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.lab_private_subnet_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.lab_private_subnet_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "icmp" # ICMP protocol
    rule_no    = 50     # Lower than the allow rule to be evaluated first
    action     = "deny"
    cidr_block = "${aws_instance.lab_instance_test.private_ip}/32"
    from_port  = 0 # -1 means all ICMP types
    to_port    = 0 # -1 means all ICMP codes
  }

  tags = {
    Name = "Lab Network ACL"
  }
}
