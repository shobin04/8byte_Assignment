output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = aws_db_instance.this.identifier
}

output "db_secret_arn" {
  value = aws_db_instance.this.master_user_secret[0].secret_arn
}