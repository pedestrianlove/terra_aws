data "aws_iam_role" "lab_aws_config_role" {
  name = "AwsConfigRole"
}

data "aws_iam_policy" "lab_aws_config_role_policy" {
  name = "AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "lab_attach_policy_to_role" {
  role       = data.aws_iam_role.lab_aws_config_role.name
  policy_arn = data.aws_iam_policy.lab_aws_config_role_policy.arn
}
