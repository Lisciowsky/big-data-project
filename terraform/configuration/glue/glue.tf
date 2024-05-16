resource "aws_glue_connection" "postgres_conn" {
  name = "postgres_conn"
  connection_properties = {
    "JDBC_CONNECTION_URL" = "jdbc:postgresql://${var.db_instance_address}:5432/mypostgresdb"
    "USERNAME"            = var.database_username
    "PASSWORD"            = var.database_password
  }
  physical_connection_requirements {
    availability_zone = var.availability_zone
    security_group_id_list = var.db_security_group_ids
    subnet_id = var.subnet_a_id
  }
}

resource "aws_iam_role" "glue_etl_role" {
  name = "glue-etl-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_etl_policy" {
  role       = aws_iam_role.glue_etl_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_job" "sales_data_etl" {
  name        = "sales-data-etl-job"
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
  glue_version = "2.0"
}

output "glue_job_name" {
  value = aws_glue_job.sales_data_etl.name
}
