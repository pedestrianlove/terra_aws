resource "aws_launch_template" "lab_launch_template" {
  name = "LabConfig"

  # Instance configurations
  image_id      = aws_ami_from_instance.lab_scaling_ami.id
  instance_type = "t2.micro"
  key_name      = "vockey"

  vpc_security_group_ids = [data.aws_security_group.lab_web_security_group.id]

  monitoring {
    enabled = true
  }

  tags = {
    Name = "LabConfig"
  }
}

resource "aws_autoscaling_group" "lab_autoscaling_group" {
  name = "Lab Auto Scaling Group"

  min_size         = 2
  desired_capacity = 2
  max_size         = 6

  target_group_arns = [aws_lb_target_group.lab_load_balancer_target_group.arn]

  vpc_zone_identifier = [
    data.aws_subnet.lab_subnet_private_1.id,
    data.aws_subnet.lab_subnet_private_2.id
  ]

  launch_template {
    id = aws_launch_template.lab_launch_template.id
  }

  tag {
    key                 = "Name"
    value               = "Lab Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "lab_autoscaling_policy" {
  name                   = "LabScalingPolicy"
  autoscaling_group_name = aws_autoscaling_group.lab_autoscaling_group.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}
