data "aws_subnet" "lab_public_subnet_1" {
  vpc_id = data.aws_vpc.lab_vpc.id
  filter {
    name   = "tag:Name"
    values = ["Public Subnet 1"]
  }
}

data "aws_subnet" "lab_public_subnet_2" {
  vpc_id = data.aws_vpc.lab_vpc.id
  filter {
    name   = "tag:Name"
    values = ["Public Subnet 2"]
  }
}

# Application Load Balancer
resource "aws_lb" "lab_app_lb" {
  name               = "Inventory-LB"
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.lab_public_subnet_1.id,
    data.aws_subnet.lab_public_subnet_2.id,
  ]
  security_groups = [aws_security_group.lab_sg.id]
}

# Target Group for ECS tasks
resource "aws_lb_target_group" "lab_app_tg" {
  name        = "Inventory-App"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.lab_vpc.id
  health_check {
    interval          = 10
    healthy_threshold = 2
  }
}

# Listener to forward HTTP requests to the target group
resource "aws_lb_listener" "lab_app_lb_listener" {
  load_balancer_arn = aws_lb.lab_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab_app_tg.arn
  }
}

output "lb_dns" {
  value       = aws_lb.lab_app_lb.dns_name
  description = "Load Balancer DNS"
}
