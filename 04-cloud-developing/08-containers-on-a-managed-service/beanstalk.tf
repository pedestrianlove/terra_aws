resource "aws_elastic_beanstalk_application" "lab_beanstalk_app" {
  name = "MyNodeApp"
}
resource "aws_elastic_beanstalk_environment" "lab_beanstalk_env" {
  name                = "MyEnv"
  application         = aws_elastic_beanstalk_application.lab_beanstalk_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.5.0 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = data.aws_security_group.lab_security_group.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = data.aws_vpc.lab_vpc.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${data.aws_subnet.lab_public_subnet_1.id},${aws_subnet.lab_public_subnet_2.id}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_DB_HOST"
    value     = aws_rds_cluster.lab_aurora_cluster.endpoint
  }
}

data "aws_ecr_repository" "lab_ecr_repo" {
  name = "cafe/node-web-app"
}

# Embed the following content into a file, and then upload it to S3
# {
# "AWSEBDockerrunVersion": "1",
# "Image": {
#     "Name": "${data.aws_ecr_repository.lab_ecr_repo.repository_url}",
#     "Update": "true"
# },
# "Ports": [ { "ContainerPort" : 3000 } ]
# }

# resource "local_file" "lab_dockerrun_file" {
#   content = jsonencode({
#     AWSEBDockerrunVersion = "1"
#     Image = {
#       Name   = data.aws_ecr_repository.lab_ecr_repo.repository_url
#       Update = "true"
#     }
#     Ports = [{ ContainerPort = 3000 }]
#   })
#   filename = "Dockerrun.aws.json"
# }
#
# resource "aws_s3_bucket" "lab_s3_bucket" {
#   bucket = "lab-ide-s3-bucket"
# }
# resource "aws_s3_bucket_object" "lab_s3_object" {
#   bucket = aws_s3_bucket.lab_s3_bucket.id
#   key    = local_file.lab_dockerrun_file.filename
#   source = local_file.lab_dockerrun_file.filename
# }
#
# resource "aws_elastic_beanstalk_application_version" "lab_beanstalk_app_version" {
#   name        = "MyNodeApp-version-1a"
#   application = aws_elastic_beanstalk_application.lab_beanstalk_app.name
#   bucket      = aws_s3_bucket.lab_s3_bucket.bucket
#   key         = aws_s3_bucket_object.lab_s3_object.key
# }
#
