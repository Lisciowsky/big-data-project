resource "aws_s3_bucket" "sales_data" {
  bucket = "${terraform.workspace}-sales-data-bucket-random-string"
}

resource "aws_s3_bucket" "glue_scripts" {
  bucket = "${terraform.workspace}-glue-scripts-bucket-random-string"
}
