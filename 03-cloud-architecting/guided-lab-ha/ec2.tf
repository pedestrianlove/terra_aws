# How to get image id:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/retrieve-ecs-optimized_AMI.html
locals {
  ec2_launch_script = <<EOF
#!/bin/bash
# Install Apache Web Server and PHP
yum install -y httpd mysql
amazon-linux-extras install -y php7.2
# Download Lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-3-113230/12-lab-mod10-guided-Scaling/s3/scripts/inventory-app.zip
unzip inventory-app.zip -d /var/www/html/
# Download and install the AWS SDK for PHP
wget https://github.com/aws/aws-sdk-php/releases/download/3.62.3/aws.zip
unzip aws -d /var/www/html
# Turn on web server
chkconfig httpd on
service httpd start
EOF
}
data "aws_instance" "lab_web_server" {
  instance_tags = {
    Name = "Web Server 1"
  }
}
resource "aws_ami_from_instance" "lab_ami" {
  name               = "Web Server AMI"
  description        = "Lab AMI for Web Server"
  source_instance_id = data.aws_instance.lab_web_server.id
}

resource "aws_launch_template" "lab_ec2_template" {
  name          = "Inventory-LT"
  image_id      = aws_ami_from_instance.lab_ami.id
  instance_type = "t2.micro"

  key_name = "vockey"
  iam_instance_profile {
    name = "Inventory-App-Role"
  }
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [data.aws_security_group.lab_sg_app.id]

  user_data = base64encode(local.ec2_launch_script)
}

data "aws_subnet" "lab_private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["Private Subnet 1"]
  }
}
data "aws_subnet" "lab_private_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["Private Subnet 2"]
  }
}


resource "aws_autoscaling_group" "lab_ec2_autoscaling_group" {
  name = "Inventory-ASG"
  target_group_arns = [
    aws_lb_target_group.lab_app_tg.arn
  ]

  vpc_zone_identifier = [
    data.aws_subnet.lab_private_subnet_1.id,
    data.aws_subnet.lab_private_subnet_2.id,
  ]
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  health_check_type         = "ELB"
  health_check_grace_period = 90

  # enabled_metrics = "true"

  launch_template {
    id      = aws_launch_template.lab_ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Inventory-App"
    propagate_at_launch = true
  }
}
