variable "project_name" {
    description = "Project name from root directory"
    type              = string
}

variable "vpc_cidr" {
    description = "CIDR block from root directory"
    type              = string
}

variable "enable_dns_support" {
    description = "Enable DNS support inside the VPC"
    type              = bool
    default          = true
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames inside the VPC"
    type              = bool
    default         = true 
}

variable "azs" {
    description = "Availability zones to use"
    type             = list(string)
}

variable "private_subnet_cidrs" {
    description = "CIDR blocks for private subnets (one per AZ)"
    type             = list(string)
  
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for public subnets (one per AZ)"
    type             = list(string)
  
}