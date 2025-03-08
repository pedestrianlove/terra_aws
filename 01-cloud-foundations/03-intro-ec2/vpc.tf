# Create VPC and IGW
data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

# Create VPC Security Group
resource "aws_security_group" "lab_security_group" {
  name        = "Web Server security group"
  description = "Security group for my web server"
  vpc_id      = data.aws_vpc.lab_vpc.id
}
resource "aws_vpc_security_group_ingress_rule" "lab_security_ingress" {
  security_group_id = aws_security_group.lab_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}
# DEBUG SSH用
resource "aws_vpc_security_group_ingress_rule" "lab_security_ingress_ssh" {
  security_group_id = aws_security_group.lab_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "lab_security_egress" {
  security_group_id = aws_security_group.lab_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
