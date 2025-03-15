data "aws_cloudwatch_log_group" "lab_cloudwatch_log_group" {
  name = "CloudTrailLogGroup"
}

resource "aws_cloudwatch_log_metric_filter" "lab_cloudwatch_metric_filter" {
  name           = "ConsoleLoginErrors"
  log_group_name = data.aws_cloudwatch_log_group.lab_cloudwatch_log_group.name
  pattern        = "\"{ ($.eventName = ConsoleLogin) && ($.errorMessage = 'Failed authentication') }\""

  metric_transformation {
    name      = "ConsoleLoginFailureCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "lab_cloudwatch_alarm" {
  alarm_name = "FailedLogins"

  # Metric info
  metric_name = aws_cloudwatch_log_metric_filter.lab_cloudwatch_metric_filter.metric_transformation[0].name
  namespace   = aws_cloudwatch_log_metric_filter.lab_cloudwatch_metric_filter.metric_transformation[0].namespace

  period              = 180
  evaluation_periods  = 1
  statistic           = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 3

  # Action
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.lab_sns_topic.arn]
}
