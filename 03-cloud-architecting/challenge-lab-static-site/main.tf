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

# Fetch the current AWS caller identity (to use its ARN in the policy)
data "aws_caller_identity" "current" {}
