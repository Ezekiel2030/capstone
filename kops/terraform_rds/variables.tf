variable "project_name" {
  description = "Project name used for naming and tagging RDS resources"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name for the kOps cluster (used in IAM role trust relationship)"
  type        = string  
}

variable "kops_bucket_name" {
  description = "S3 bucket name used by kOps for state storage"
  type        = string  
}

variable "account_id" {
  description = "AWS account ID for the existing infra"
  type        = string  
}

variable "vpc_id" {
  description = "VPC ID from the existing infra"
  type = string
}

variable "aws_region" {
  description = "AWS region for the RDS instance"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS subnet group in a linear list of strings"
  type        = list(string)
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "taskapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "taskapp_user"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.6"
}
