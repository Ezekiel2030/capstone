resource "aws_vpc" "this" {
    cidr_block                         = var.vpc_cidr
    enable_dns_support      = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = {
        Name           = "${var.project_name}-vpc"
        Project         = var.project_name
    } 
}

resource "aws_subnet" "public" {
  count = length(var.azs)
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index +1)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name   = "${var.project_name}-public-${var.azs[count.index]}"
    Project = var.project_name
    Tier       = "public"
  }
}

resource "aws_subnet" "private" {
  count = length(var.azs)
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index +101)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name   = "${var.project_name}-private-${var.azs[count.index]}"
    Project = var.project_name
    Tier       = "private"
  }
}