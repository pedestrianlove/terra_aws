resource "aws_sns_topic_subscription" "lab_sns_subscription" {
  topic_arn = aws_sns_topic.lab_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.lab_prd_queue.arn
}
