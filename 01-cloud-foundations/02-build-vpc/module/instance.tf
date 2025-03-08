# Launch Web Server
resource "aws_instance" "lab_instance" {
  ami           = "ami-0ace34e9f53c91c5d"
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.lab_public_subnet_b.id
  vpc_security_group_ids = [
    aws_security_group.lab_security_group.id
  ]
  user_data = <<EOF
    #!/bin/bash
    # Install Apache Web Server and PHP
    yum install -y httpd wget php mysql
    # Download Lab files
    wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
    unzip lab-app.zip -d /var/www/html/
    # Turn on web server
    chkconfig httpd on
    service httpd start
  EOF

  tags = {
    Name = "Web Server 1"
  }
}
