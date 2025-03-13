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

data "aws_instance" "lab_snapshot_instance" {
  instance_tags = {
    Name = "Web Server 1"
  }
}

resource "aws_ami_from_instance" "lab_scaling_ami" {
  name               = "WebServerAMI"
  description        = "Lab AMI for Web Server"
  source_instance_id = data.aws_instance.lab_snapshot_instance.id

  tags = {
    Name = "WebServerAMI"
  }
}


