resource "aws_cloudwatch_event_rule" "every_hour" {
  name        = "RunEveryHour"
  description = "Trigger Lambda function every hour"
  schedule_expression = "cron(0 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = "lambda"
  arn       = aws_lambda_function.generate_data.arn
}