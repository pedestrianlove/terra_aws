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
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
provider "aws" {
  alias  = "east"
  region = "us-east-2"
}

# Role
data "aws_iam_role" "s3_crr_role" {
  name = "S3-CRR-Role"
}
