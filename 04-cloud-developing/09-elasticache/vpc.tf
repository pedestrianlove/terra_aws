data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "IDE VPC"
  }
}

data "aws_security_group" "lab_sg_memcache" {
  tags = {
    "aws:cloudformation:logical-id" = "ClusterSecurityGroup"
  }
}

data "aws_security_group" "lab_sg_ide" {
  name = "Lab IDE SG"
}

resource "aws_vpc_security_group_ingress_rule" "lab_aurora_sg_ingress_memcache" {
  security_group_id = data.aws_security_group.lab_sg_memcache.id

  referenced_security_group_id = data.aws_security_group.lab_sg_memcache.id
  from_port                    = 11211
  ip_protocol                  = "tcp"
  to_port                      = 11211
}

resource "aws_vpc_security_group_ingress_rule" "lab_ide_sg_ingress_memcache" {
  security_group_id = data.aws_security_group.lab_sg_memcache.id

  referenced_security_group_id = data.aws_security_group.lab_sg_ide.id
  from_port                    = 11211
  ip_protocol                  = "tcp"
  to_port                      = 11211
}
