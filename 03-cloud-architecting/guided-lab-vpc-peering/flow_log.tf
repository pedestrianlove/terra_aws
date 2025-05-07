resource "aws_cloudwatch_log_group" "shared_vpc_log_group" {
  name = "ShareVPCFlowLogs"
}
resource "aws_flow_log" "lab_flow_log" {
  vpc_id                   = data.aws_vpc.shared_vpc.id
  iam_role_arn             = data.aws_iam_role.vpc_flow_log_role.arn
  log_destination          = aws_cloudwatch_log_group.shared_vpc_log_group.arn
  traffic_type             = "ALL"
  max_aggregation_interval = 60
}

