terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

resource "aws_security_group" "lab_sg" {
  name        = "Inventory-LB"
  description = "Enable web access to load balancer"
  vpc_id      = data.aws_vpc.lab_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "lab_vpc_ingress_http" {
  security_group_id = aws_security_group.lab_sg.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "lab_vpc_ingress_https" {
  security_group_id = aws_security_group.lab_sg.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

data "aws_security_group" "lab_sg_app" {
  name = "Inventory-App"
}

resource "aws_vpc_security_group_ingress_rule" "lab_vpc_ingress_http_app" {
  security_group_id            = data.aws_security_group.lab_sg_app.id
  referenced_security_group_id = aws_security_group.lab_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Traffic from load balancer"
}

data "aws_security_group" "lab_sg_db" {
  name = "Inventory-DB"
}
resource "aws_vpc_security_group_ingress_rule" "lab_vpc_ingress_mysql_db" {
  security_group_id            = data.aws_security_group.lab_sg_db.id
  referenced_security_group_id = data.aws_security_group.lab_sg_app.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Traffic from application servers"
}
