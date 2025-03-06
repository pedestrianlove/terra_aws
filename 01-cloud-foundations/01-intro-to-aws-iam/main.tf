terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group_membership" "s3_support_group_membership" {
  name = "s3-support-group-membership"

  group = "S3-Support"
  users = ["user-1"]
}

resource "aws_iam_group_membership" "ec2_support_group_membership" {
  name = "ec2-support-group-membership"

  group = "EC2-Support"
  users = ["user-2"]
}

resource "aws_iam_group_membership" "ec2_admin_group_membership" {
  name = "ec2-admin-group-membership"

  group = "EC2-Admin"
  users = ["user-3"]
}
