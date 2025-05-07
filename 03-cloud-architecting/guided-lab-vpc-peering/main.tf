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

data "aws_iam_role" "vpc_flow_log_role" {
  name = "Vpc-flow-logs-Role"
}
