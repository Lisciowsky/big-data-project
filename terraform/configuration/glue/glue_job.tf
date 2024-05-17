resource "aws_glue_job" "sales_data_etl" {
  name        = "${terraform.workspace}-sales-data-etl-job"
  role_arn    = aws_iam_role.glue_etl_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://${var.script_bucket}/scripts/sales_data_etl_script.py"
    python_version  = "3"
  }
  default_arguments = {
    "--job-language"         = "python"
    "--TempDir"              = "s3://${var.temp_dir}/temp/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-glue-datacatalog" = "true"
  }
  max_capacity = 2.0 # smallest capacity for Glue jobs
  glue_version = "3.0"
}