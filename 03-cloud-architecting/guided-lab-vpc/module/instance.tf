# Launch Web Server
resource "aws_instance" "lab_instance" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami                         = "ami-08b5b3a93ed654d19" # AL2023
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = aws_subnet.lab_public_subnet_a.id
  associate_public_ip_address = true
  # vpc_security_group_ids = [
  #   aws_security_group.lab_security_group.id
  # ]
  user_data = <<EOF
#!/bin/bash

# Install Apache Web Server and PHP
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
dnf install -y mariadb105-server

# Download Lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/06-lab-mod7-guided-VPC/s3/scripts/al2023-inventory-app.zip -O inventory-app.zip
unzip inventory-app.zip -d /var/www/html/

# Download and install the AWS SDK for PHP
wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
unzip aws.zip -d /var/www/html

# Turn on web server
systemctl enable httpd
systemctl start httpd
  EOF

  tags = {
    Name = "App Server"
  }
}
