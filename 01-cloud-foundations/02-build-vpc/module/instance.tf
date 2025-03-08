# Launch Web Server
resource "aws_instance" "lab_instance" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami                         = "ami-08b5b3a93ed654d19" # AL2023
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = aws_subnet.lab_public_subnet_b.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.lab_security_group.id
  ]
  user_data = <<EOF
#!/bin/bash

# Install Apache Web Server and PHP
dnf install -y httpd wget php mariadb105-server ec2-instance-connect

# Download Lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/

# Turn on web server
chkconfig httpd on
service httpd start

# Test

  EOF

  tags = {
    Name = "Web Server 1"
  }
}
