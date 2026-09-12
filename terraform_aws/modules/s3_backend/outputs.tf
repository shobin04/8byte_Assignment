output "bucket_arn" {
  value = aws_s3_bucket.state_bucket.arn
}

output "bucket_id" {
  value = aws_s3_bucket.state_bucket.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB state locking table"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB state locking table"
  value       = aws_dynamodb_table.terraform_locks.arn
}