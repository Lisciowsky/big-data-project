provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "networking" {
  source     = "./networking"
  aws_region = var.aws_region
}

module "security" {
  source = "./configuration/security"
  vpc_id = module.networking.vpc_id
}

module "database" {
  source = "./configuration/database"

  vpc_id                = module.networking.vpc_id
  db_subnet_group_name  = module.networking.db_subnet_group_name
  db_security_group_ids = [module.security.rds_sg_id]
  database_username     = var.database_username
  database_password     = var.database_password
}

module "s3" {
  source = "./configuration/s3"
}

module "glue" {
  source                = "./configuration/glue"
  db_security_group_ids = [module.security.rds_sg_id]
  db_subnet_group_name  = module.networking.db_subnet_group_name
  database_username     = var.database_username
  database_password     = var.database_password
  availability_zone     = module.networking.subnet_a_availability_zone
  db_instance_address   = module.database.db_instance_address
  subnet_a_id           = module.networking.subnet_a_id
  script_bucket         = module.s3.sales_data_bucket_name
  temp_dir              = module.s3.sales_data_bucket_name
  database_name = var.database_name
  sales_data_bucket = module.s3.sales_data_bucket_name
  
}

resource "aws_glue_catalog_database" "default" {
  name = "default"
}

module "ecr" {
  source = "./configuration/ecr"
}

module "lambda" {
  source = "./configuration/lambda"
  aws_region = var.aws_region
  bucket_name = module.s3.sales_data_bucket_name
  file_prefix = "sales_data"
  ecr_repository_url = module.ecr.ecr_repository_url
  aws_caller_identity_id = data.aws_caller_identity.current.id
}