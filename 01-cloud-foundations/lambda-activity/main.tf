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

data "aws_instance" "lab_instance" {
  instance_tags = {
    Name = "instance1"
  }
}

