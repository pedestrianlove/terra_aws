# Create VPC and IGW
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

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
  name        = "App-SG"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    description = "Allow web access"
  }
}
