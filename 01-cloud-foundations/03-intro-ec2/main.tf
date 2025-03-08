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

# Launch Web Server
resource "aws_instance" "lab_web_server" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami                         = "ami-08b5b3a93ed654d19" # AL2023
  instance_type               = "t2.small"
  key_name                    = "vockey"
  subnet_id                   = data.aws_subnet.lab_public_subnet_1.id
  associate_public_ip_address = true
  disable_api_termination     = true
  disable_api_stop            = true
  root_block_device {
    volume_size = 10
  }
  vpc_security_group_ids = [
    aws_security_group.lab_security_group.id
  ]
  user_data = <<EOF
#!/bin/bash
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html
  EOF

  tags = {
    Name = "Web Server"
  }
}
