resource "aws_glue_workflow" "etl_workflow" {
  name = "${terraform.workspace}-etl-workflow"
}

resource "aws_glue_trigger" "crawler_trigger" {
  name          = "${terraform.workspace}-crawler-trigger"
  workflow_name = aws_glue_workflow.etl_workflow.name
  type          = "SCHEDULED"
  schedule      = "cron(50 * * * ? *)"

  actions {
    crawler_name = aws_glue_crawler.s3_crawler.name
  }
}

resource "aws_glue_trigger" "etl_job_trigger" {
  name           = "${terraform.workspace}-etl-job-trigger"
  workflow_name  = aws_glue_workflow.etl_workflow.name
  type           = "CONDITIONAL"
  predicate {
    conditions {
      crawler_name = aws_glue_crawler.s3_crawler.name
      state        = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.sales_data_etl.name
  }
}
