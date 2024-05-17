resource "aws_glue_catalog_database" "data_lake" {
  name = "${terraform.workspace}-data-lake-db"
}

resource "aws_glue_crawler" "s3_crawler" {
  name          = "s3-data-lake-crawler"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.data_lake.name
  table_prefix  = "etl_"

  s3_target {
    path = "s3://${var.sales_data_bucket}/"
  }

  schedule = "cron(50 * * * ? *)"  # Every hour at 50 minutes past the hour
}
