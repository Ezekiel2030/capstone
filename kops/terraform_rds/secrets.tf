# 1. Define the Secret container
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "project/capstone/database_credentials"
  description = "Database credentials for capstone project"
}

# 2. Define the Secret Version (The actual data)
resource "aws_secretsmanager_secret_version" "db_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  
  # Use jsonencode to create a valid JSON string for the secret
  secret_string = jsonencode({
    DATABASE_HOST     = split(":", aws_db_instance.postgres.endpoint)[0]
    DATABASE_PORT     = split(":", aws_db_instance.postgres.endpoint)[1]  
    DATABASE_NAME     = var.db_name
    DATABASE_PASSWORD = var.db_password
    DATABASE_USER = var.db_username
  })
}

