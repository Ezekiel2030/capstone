provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-terraform-state"

  tags = {
    Name    = "${var.project_name}-terraform-state"
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "kops_state" {
  bucket = "${var.project_name}-kops-state"

  tags = {
    Name    = "${var.project_name}-kops-state"
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "kops_state_versioning" {
  bucket = aws_s3_bucket.kops_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kops_state_encryption" {
  bucket = aws_s3_bucket.kops_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "kops_state_ownership" {
  bucket = aws_s3_bucket.kops_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "kops_state_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.kops_state_ownership]

  bucket = aws_s3_bucket.kops_state.id
  acl    = "private" 
}

resource "aws_s3_bucket_public_access_block" "kops_state_block" {
  bucket = aws_s3_bucket.kops_state.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project_name}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "${var.project_name}-terraform-locks"
    Project = var.project_name
  }
}