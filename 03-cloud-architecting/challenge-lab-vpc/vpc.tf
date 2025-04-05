data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = data.aws_vpc.lab_vpc.id

  tags = {
    Name = "lab-igw"
  }
}

# bastion host
resource "aws_security_group" "lab_sg_bastion" {
  name   = "Bastion Host SG"
  vpc_id = data.aws_vpc.lab_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc_security_group_ingress_rule" "lab_security_ingress_ssh" {
  security_group_id = aws_security_group.lab_sg_bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

# Private instance
resource "aws_security_group" "lab_sg_private" {
  name   = "Private Instance SG"
  vpc_id = data.aws_vpc.lab_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc_security_group_ingress_rule" "lab_sg_private_ingress_ssh" {
  security_group_id = aws_security_group.lab_sg_private.id

  referenced_security_group_id = aws_security_group.lab_sg_bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

# Test SG
resource "aws_security_group" "lab_sg_test" {
  name   = "Test SG"
  vpc_id = data.aws_vpc.lab_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Allow all ICMPv4 traffic
resource "aws_vpc_security_group_ingress_rule" "lab_sg_test_ingress_ping" {
  security_group_id = aws_security_group.lab_sg_test.id
  ip_protocol       = "icmp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
}
