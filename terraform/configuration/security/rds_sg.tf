resource "aws_security_group" "rds_sg" {
  name   = "${terraform.workspace}_rds_sg"
  vpc_id = var.vpc_id

  # NOTE Potentially dangerous rule - use jumphost to connect to production db instead:
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}