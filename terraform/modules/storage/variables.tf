variable "project_name" {
  description = "Project name used for backend resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket for backend"
  type = string
}

variable "kops_bucket_name" {
  description = "S3 bucket for kops"
  type = string
}

variable "table_name" {
  description = "DynamoDB for backend"
  type = string
}