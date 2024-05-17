output "db_instance_address" {
  value = module.database.db_instance_address
}

output "data_bucket_name" {
  value = module.s3.sales_data_bucket_name
}

output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}