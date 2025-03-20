resource "aws_config_configuration_recorder" "lab_aws_config_recorder" {
  role_arn = data.aws_iam_role.lab_aws_config_role.arn

  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types                = ["AWS::EC2::SecurityGroup"]
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

# Setup the S3 bucket for configuration recorder
resource "aws_s3_bucket" "lab_aws_config_bucket" {
  # bucket = "awsconfig-bucket-test"
  bucket = "i-am-testing-bucket-recorder-config-aws"
}
resource "aws_config_delivery_channel" "lab_aws_config_delivery_channel" {
  s3_bucket_name = aws_s3_bucket.lab_aws_config_bucket.bucket
  depends_on     = [aws_config_configuration_recorder.lab_aws_config_recorder]
}

# Start the configuration recorder
resource "aws_config_configuration_recorder_status" "lab_aws_config_enable_recorder" {
  name       = aws_config_configuration_recorder.lab_aws_config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.lab_aws_config_delivery_channel]
}
