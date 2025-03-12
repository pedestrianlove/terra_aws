data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

data "aws_security_group" "lab_web_security_group" {
  tags = {
    Name = "Web Security Group"
  }
}

# Create VPC Security Group
resource "aws_security_group" "lab_rds_security_group" {
  name        = "DB Security Group"
  description = "Permit access from Web Security Group"
  vpc_id      = data.aws_vpc.lab_vpc.id
}
resource "aws_vpc_security_group_ingress_rule" "lab_allow_rds" {
  security_group_id            = aws_security_group.lab_rds_security_group.id
  referenced_security_group_id = data.aws_security_group.lab_web_security_group.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}
