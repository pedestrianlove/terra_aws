data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_function_payload.zip"
  source {
    content  = <<EOF
import boto3
region = 'us-east-1'
instances = ['${data.aws_instance.lab_instance.id}']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
    EOF
    filename = "lambda_function.py"
  }
}

data "aws_iam_role" "iam_for_lambda" {
  name = "myStopinatorRole"
}

resource "aws_lambda_function" "lab_stopinator" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name    = "myStopinator"
  role             = data.aws_iam_role.iam_for_lambda.arn
  filename         = "lambda_function_payload.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}
