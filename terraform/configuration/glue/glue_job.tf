resource "aws_glue_job" "sales_data_etl" {
  name        = "sales-data-etl-job"
  role_arn    = aws_iam_role.glue_etl_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://path-to-your-glue-script/sales_data_etl_script.py"
    python_version  = "3"
  }
  default_arguments = {
    "--job-language"         = "python"
    "--extra-py-files"       = "s3://path-to-your-glue-dependencies/dependency.zip"
    "--TempDir"              = "s3://your-temp-dir/temp/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-glue-datacatalog" = "true"
  }
  max_capacity = 2.0 # smallest capacity for Glue jobs
  glue_version = "2.0"
}