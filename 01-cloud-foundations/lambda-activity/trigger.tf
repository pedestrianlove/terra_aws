resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  statement_id  = "myStopinatorEvent"
  function_name = aws_lambda_function.lab_stopinator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lab_event_rule.arn

  depends_on = [aws_lambda_function.lab_stopinator]
}

resource "aws_cloudwatch_event_rule" "lab_event_rule" {
  name = "everyMinute"

  schedule_expression = "rate(1 minute)"
}
