data "aws_security_group" "lab_sg" {
  tags = {
    Name = "LabSG1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lab_sg_ingress_https" {
  security_group_id = data.aws_security_group.lab_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "lab_sg_ingress_imap" {
  security_group_id = data.aws_security_group.lab_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 993
  to_port           = 993
}
resource "aws_vpc_security_group_ingress_rule" "lab_sg_ingress_smtp" {
  security_group_id = data.aws_security_group.lab_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 465
  to_port           = 465
}
