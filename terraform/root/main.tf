module "core" {
  source = "../modules/core"

  project_name = var.project_name
  aws_region   = var.aws_region
  azs          = var.azs
}

module "vpc" {
  source = "../modules/vpc"

  project_name              = var.project_name
  vpc_cidr                        = var.vpc_cidr
  azs                                 = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "billing_alert" {
  source            = "../modules/billing"
  
  budget_name       = var.budget_name
  limit_amount      = var.limit_amount
  threshold         = var.threshold
  subscriber_emails = var.subscriber_emails
}

module "backend_storage" {
  source = "../modules/storage"

 project_name = var.project_name
 aws_region = var.aws_region
 s3_bucket_name = var.s3_bucket_name
kops_bucket_name = var.kops_bucket_name
 table_name = var.table_name
}
