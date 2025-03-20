resource "aws_config_config_rule" "lab_config_rule" {
  name        = "EC2SecurityGroup"
  description = "Restrict inbound ports to HTTP and HTTPS"

  source {
    owner = "CUSTOM_LAMBDA"
    # paste your lambda arn here
    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }
    source_identifier = "arn:aws:lambda:us-east-1:666076298554:function:awsconfig_lambda_security_group"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  input_parameters = jsonencode({
    debug = "true"
  })

  depends_on = [
    aws_config_configuration_recorder.lab_aws_config_recorder,
    aws_vpc_security_group_ingress_rule.lab_sg_ingress_imap,
    aws_vpc_security_group_ingress_rule.lab_sg_ingress_smtp
  ]
}
