#!/bin/bash

# Navigate to the terraform directory

echo "Prepare a name for your project"

echo ""

cd ..

cd terraform/root

# Provision the terraform infrastructure

echo "Provisioning AWS infra"
terraform init

terraform plan -out=path

terraform apply "path" 

echo ""

# Adding state locking 

cd ..

cd ..

cp misc/backend.ts terraform/root

cd terraform/root

sleep 15s

echo "Applying backend for state locking"

terraform init


