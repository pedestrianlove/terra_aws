data "aws_security_group" "lab_security_group" {
  tags = {
    Name = "LabSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lab_security_group_rule_ssh" {
  security_group_id = data.aws_security_group.lab_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}
