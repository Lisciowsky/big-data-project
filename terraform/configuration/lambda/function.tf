resource "aws_lambda_function" "generate_data" {
  package_type    = "Image"
  function_name   = "${terraform.workspace}-GenerateDataFunction"
  role            = aws_iam_role.lambda_role.arn
  image_uri       = "${var.ecr_repository_url}:data-feed-latest"
  timeout         = 60

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      FILE_PREFIX = var.file_prefix
    }
  }

  depends_on = [aws_iam_role_policy.lambda_policy_logging, aws_iam_role_policy.lambda_policy_s3]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_data.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}
