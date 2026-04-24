variable "project_name" {
    description = "Project name from root directory"
    type              = string
}

variable "aws_region" {
    description = "AWS region from root directory"
    type             = string
}

variable "azs" {
    description = "Availability zones from root directory"
    type             = list(string)
}