data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "IDE VPC"
  }
}

data "aws_security_group" "lab_security_group" {
  vpc_id = data.aws_vpc.lab_vpc.id
  name   = "Lab IDE SG"
}

# igw
data "aws_internet_gateway" "lab_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}

# SG ingress rule
resource "aws_vpc_security_group_ingress_rule" "lab_security_group_rule_http" {
  security_group_id = data.aws_security_group.lab_security_group.id

  cidr_ipv4   = "140.114.85.218/32"
  from_port   = 8000
  ip_protocol = "tcp"
  to_port     = 8000
}
resource "aws_vpc_security_group_ingress_rule" "lab_security_group_rule_rds" {
  security_group_id = data.aws_security_group.lab_security_group.id

  referenced_security_group_id = data.aws_security_group.lab_security_group.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}
