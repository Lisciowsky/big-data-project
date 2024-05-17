output "sales_data_bucket_arn" {
  value = aws_s3_bucket.sales_data.arn
}
output "sales_data_bucket_name" {
  value = aws_s3_bucket.sales_data.bucket_domain_name
}

output "glue_scripts_bucket_arn" {
  value = aws_s3_bucket.glue_scripts.arn
}
output "glue_scripts_bucket_name" {
  value = aws_s3_bucket.glue_scripts.bucket_domain_name
}
