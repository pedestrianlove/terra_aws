# Create VPC and IGW
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Lab VPC"
  }
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "Lab IGW"
  }
}

# Create VPC Security Group
resource "aws_security_group" "lab_security_group" {
  name        = "Web Security Group"
  description = "Enable HTTP access"
  vpc_id      = aws_vpc.lab_vpc.id
}
resource "aws_vpc_security_group_ingress_rule" "lab_security_ingress" {
  security_group_id = aws_security_group.lab_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}
