resource "aws_cloudwatch_event_rule" "lab_event_rule" {
  name           = "MonitorSecurityGroups"
  event_bus_name = "default"

  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail-type = [
      "AWS API Call via CloudTrail"
    ],
    detail = {
      eventSource = ["ec2.amazonaws.com"],
      eventName   = ["AuthorizeSecurityGroupIngress", "ModifyNetworkInterfaceAttribute"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lab_event_target" {
  arn  = aws_sns_topic.lab_sns_topic.arn
  rule = aws_cloudwatch_event_rule.lab_event_rule.name
  input_transformer {
    input_paths = {
      name   = "$.detail.requestParameters.groupId",
      source = "$.detail.eventName",
      time   = "$.time",
      value  = "$.detail",
    }
    input_template = <<EOF
"The <source> API call was made against the <name> security group on <time> with the following details:"
" <value> "
EOF
  }
}
