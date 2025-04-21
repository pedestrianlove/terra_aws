resource "aws_sns_topic" "lab_sns_topic" {
  name                        = "updated_beans_sns.fifo"
  fifo_topic                  = true
  display_name                = "updated beans sns"
  content_based_deduplication = true
}

data "aws_iam_policy_document" "beans_topic_policy_document" {
  policy_id = "BeansTopicPolicy"
  version   = "2012-10-17"

  statement {
    sid    = "BeansAllowActions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.user_id}:root"]
    }

    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:Receive",
      "SNS:AddPermission",
      "SNS:Subscribe"
    ]
    resources = [
      aws_sns_topic.lab_sns_topic.arn,
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }

  statement {
    sid    = "BeansAllowPublish"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.user_id}:root"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.lab_sns_topic.arn,
    ]
  }
}

resource "aws_sns_topic_policy" "lab_sns_topic_policy" {
  arn    = aws_sns_topic.lab_sns_topic.arn
  policy = data.aws_iam_policy_document.beans_topic_policy_document.json
}
