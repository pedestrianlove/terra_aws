resource "aws_sqs_queue" "lab_deadletter_queue" {
  name                        = "DeadLetterQueue.fifo"
  fifo_queue                  = true
  receive_wait_time_seconds   = 0
  content_based_deduplication = false
  visibility_timeout_seconds  = 20
  deduplication_scope         = "queue"
}
data "aws_iam_policy_document" "dlq_sqs_policy_document" {
  policy_id = "DlqSqsPolicy"
  version   = "2012-10-17"

  statement {
    sid    = "dead-letter-sqs"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.user_id}:root"]
    }

    actions = ["sqs:*"]
    resources = [
      aws_sqs_queue.lab_deadletter_queue.arn,
    ]
  }
}

resource "aws_sqs_queue_policy" "dlq_sqs_policy" {
  queue_url = aws_sqs_queue.lab_deadletter_queue.id
  policy    = data.aws_iam_policy_document.dlq_sqs_policy_document.json
}


resource "aws_sqs_queue" "lab_prd_queue" {
  name                        = "updated_beans.fifo"
  fifo_queue                  = true
  visibility_timeout_seconds  = 30
  receive_wait_time_seconds   = 20
  content_based_deduplication = true
  deduplication_scope         = "queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.lab_deadletter_queue.arn
    maxReceiveCount     = 5
  })
}

data "aws_iam_policy_document" "beans_sqs_policy_document" {
  policy_id = "BeansSqsPolicy"
  version   = "2012-10-17"

  statement {
    sid    = "beans-sqs"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.user_id}:root"]
    }

    actions = ["sqs:*"]
    resources = [
      aws_sqs_queue.lab_prd_queue.arn,
    ]
  }

  statement {
    sid    = "topic-subscription"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.user_id}:root"]
    }
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]
    resources = [
      aws_sqs_queue.lab_prd_queue.arn,
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        aws_sns_topic.lab_sns_topic.arn
      ]
    }
  }

  statement {
    sid    = "get-messages"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.user_id}:root",
        "arn:aws:iam::${data.aws_caller_identity.current.user_id}:role/aws-elasticbeanstalk-ec2-role"
      ]
    }

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
    ]

    resources = [
      aws_sqs_queue.lab_prd_queue.arn,
    ]
  }
}

resource "aws_sqs_queue_policy" "beans_sqs_policy" {
  queue_url = aws_sqs_queue.lab_prd_queue.id
  policy    = data.aws_iam_policy_document.beans_sqs_policy_document.json
}
