output "db_endpoint" {
  description = "Database endpoint address"
  value       = aws_db_instance.postgres.endpoint
}

output "database_sg_id" {
    description = "Database security group ID"
    value = aws_security_group.database.id
}