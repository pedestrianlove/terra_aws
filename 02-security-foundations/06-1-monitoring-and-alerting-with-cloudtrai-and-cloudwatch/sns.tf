resource "aws_sns_topic" "lab_sns_topic" {
  name = "MySNSTopic"

  # Access policy
  ## Everyone can publish/subscribe

  tags = {
    Name = "MySNSTopic"
  }
}

resource "aws_sns_topic_subscription" "lab_sns_topic_subscription" {
  topic_arn = aws_sns_topic.lab_sns_topic.arn
  protocol  = "email"
  endpoint  = "jsli@linux.com"
}
