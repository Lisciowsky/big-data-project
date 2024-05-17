variable "aws_region" {
  default = "eu-central-1"
}

variable "database_username" {
  description = "db username"
  type        = string
  default     = "username"
}
variable "database_password" {
  description = "db password"
  type        = string
  default     = "password"
}

variable "database_name" {
  type = string
  default = "sales_db"
}