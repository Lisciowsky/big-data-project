resource "aws_glue_connection" "postgres_conn" {
  name = "${terraform.workspace}-postgres-conn"
  connection_properties = {
    "JDBC_CONNECTION_URL" = "jdbc:postgresql://${var.db_instance_address}:5432/${var.database_name}"
    "USERNAME"            = var.database_username
    "PASSWORD"            = var.database_password
  }
  physical_connection_requirements {
    availability_zone = var.availability_zone
    security_group_id_list = var.db_security_group_ids
    subnet_id = var.subnet_a_id
  }
}
