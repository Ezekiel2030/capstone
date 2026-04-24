#!/bin/bash

# Navigate to the database folder
 cd ..

 cd kops/terraform_rds

 echo "You need to re-input your project name"
 echo "Make sure you have your database password ready"
 echo "VPC ID is required"
 echo "Private subnet ids are required in a list of strings"
 echo "AWS region is required"
 echo "Cluster name is required"
 echo "Account ID is required"
 echo "Kops bucket name is required"

 sleep 30s

 echo ""

 echo "Starting database proviioning for the kops cluster"

 terraform init
 terraform plan -out=path
 terraform apply "path"
