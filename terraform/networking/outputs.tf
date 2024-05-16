output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}
output "subnet_a_availability_zone" {
  value = aws_subnet.subnet_a.availability_zone
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id

}
output "subnet_b_availability_zone" {
  value = aws_subnet.subnet_b.availability_zone
}


output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.name
}
