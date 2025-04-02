data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}
data "aws_subnets" "lab_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}

data "aws_security_group" "lab_efs_client_security_group" {
  tags = {
    Name = "EFSClient"
  }
}

resource "aws_security_group" "lab_efs_security_group" {
  name        = "EFS Mount Target"
  description = "Inbound NFS access from EFS clients"
  vpc_id      = data.aws_vpc.lab_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EFS Mount Target"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lab_efs_security_group_ingress_rule" {
  security_group_id            = aws_security_group.lab_efs_security_group.id
  referenced_security_group_id = data.aws_security_group.lab_efs_client_security_group.id

  ip_protocol = "tcp"
  from_port   = 2049
  to_port     = 2049
}

resource "aws_efs_file_system" "lab_efs" {
  tags = {
    Name = "My First EFS File System"
  }
}

resource "aws_efs_mount_target" "lab_efs_mount_target" {
  # Create a mount target in each of the subnets
  for_each  = toset(data.aws_subnets.lab_public_subnets.ids)
  subnet_id = each.value

  file_system_id = aws_efs_file_system.lab_efs.id
  security_groups = [
    aws_security_group.lab_efs_security_group.id
  ]
}
