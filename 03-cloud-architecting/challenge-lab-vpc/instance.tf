resource "aws_instance" "lab_instance_bastion" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami                         = "ami-08b5b3a93ed654d19" # AL2023
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = aws_subnet.lab_public_subnet_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.lab_sg_bastion.id
  ]

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "lab_instance_test" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami                         = "ami-08b5b3a93ed654d19" # AL2023
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = aws_subnet.lab_public_subnet_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.lab_sg_test.id
  ]

  tags = {
    Name = "Test Instance"
  }
}
# resource "aws_key_pair" "lab_key_pair_vockey2" {
#   key_name   = "vockey2"
#   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFi9S4MEqI2KeG0G6Lwm1wrS+yeN27toCz9VyPlRWDC jsl@lab-tr"
#
#   tags = {
#     Name = "vockey2"
#   }
# }

resource "aws_instance" "lab_instance_private" {
  #ami = "ami-0ace34e9f53c91c5d" # AL2
  ami           = "ami-08b5b3a93ed654d19" # AL2023
  instance_type = "t2.micro"
  key_name      = "vockey"
  subnet_id     = aws_subnet.lab_private_subnet_a.id
  vpc_security_group_ids = [
    aws_security_group.lab_sg_private.id
  ]

  tags = {
    Name = "Private Instance"
  }
}

