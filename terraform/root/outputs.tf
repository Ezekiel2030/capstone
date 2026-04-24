output "project_context" {
    description = "Project context returned from core module"
    value           = module.core.project_context 
}

output "vpc_id" {
    description = "VPC ID returned from vpc module"
    value           = module.vpc.vpc_id  
}

output "vpc_public_subnets" {
  description = "Public subnets returned from vpc"
  value = module.vpc.public_subnet_ids
}

output "vpc_private_subnets" {
  description = "Private subnets returned from vpc"
  value = module.vpc.private_subnet_ids
}

output "s3_state_store" {
  description = "S3 bucket for state locking"
  value = module.backend_storage.state_bucket_name
}

output "kops_state_store" {
  description = "S3 bucket for kops cluster backups"
  value = module.backend_storage.kops_state_bucket_name
}