data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

data "aws_subnet" "lab_subnet_public_1" {
  tags = {
    Name = "Public Subnet 1"
  }
}
data "aws_subnet" "lab_subnet_public_2" {
  tags = {
    Name = "Public Subnet 2"
  }
}
data "aws_subnet" "lab_subnet_private_1" {
  tags = {
    Name = "Private Subnet 1"
  }
}
data "aws_subnet" "lab_subnet_private_2" {
  tags = {
    Name = "Private Subnet 2"
  }
}


data "aws_security_group" "lab_web_security_group" {
  tags = {
    Name = "Web Security Group"
  }
}

# Create load balancer
resource "aws_lb_target_group" "lab_load_balancer_target_group" {
  name     = "LabGroup"
  vpc_id   = data.aws_vpc.lab_vpc.id
  port     = 80
  protocol = "HTTP"

  tags = {
    Name = "LabGroup"
  }
}
resource "aws_lb" "lab_load_balancer" {
  name               = "LabELB"
  load_balancer_type = "application"


  security_groups = [data.aws_security_group.lab_web_security_group.id]
  subnets         = [data.aws_subnet.lab_subnet_public_1.id, data.aws_subnet.lab_subnet_public_2.id]

  tags = {
    Name = "LabELB"
  }
}
resource "aws_lb_listener" "lab_load_balancer_listener" {
  load_balancer_arn = aws_lb.lab_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab_load_balancer_target_group.arn
  }
}
