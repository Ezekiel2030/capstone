output "state_bucket_name" {
  description = "S3 bucket used for Terraform remote state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "kops_state_bucket_name" {
  description = "S3 bucket used for the kops cluster"
  value            = aws_s3_bucket.kops_state.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}