variable "db_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "database_username" {
  type = string
}

variable "database_password" {
  type = string
}

variable "database_name" {
  type = string
}
variable "db_instance_address" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "subnet_a_id" {
  type = string
}

variable "sales_data_bucket" {
  description = "The s3 bucket with sales data"
  type = string
}

variable "script_bucket" {
  description = "The S3 bucket where the Glue ETL script is stored"
  type        = string
}

variable "temp_dir" {
  description = "The S3 bucket for Glue temporary data"
  type        = string
}
