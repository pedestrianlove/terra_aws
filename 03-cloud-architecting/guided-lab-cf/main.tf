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

resource "aws_cloudformation_stack" "lab_network" {
  name = "lab-network"

  template_url = "https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/14-lab-mod11-guided-CFn/s3/scripts/lab-network.yaml"

  tags = {
    application = "inventory"
  }
}

resource "aws_cloudformation_stack" "lab_app" {
  name = "lab-application"

  template_url = "https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/14-lab-mod11-guided-CFn/s3/scripts/lab-application.yaml"

  tags = {
    application = "inventory"
  }

  depends_on = [aws_cloudformation_stack.lab_network]
}

# resource "aws_cloudformation_stack" "lab_app2" {
#   name = "lab-application"
#
#   template_url = "https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/14-lab-mod11-guided-CFn/s3/scripts/lab-application2.yaml"
#
#   tags = {
#     application = "inventory"
#   }
#
#   depends_on = [aws_cloudformation_stack.lab_app]
# }
