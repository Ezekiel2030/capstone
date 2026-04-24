#!/bin/bash

set -euo pipefail

# Setting up kOps
# kOps setup variables
# 1. The name of your cluster (Must end with your Route53 domain)
NAME=clusters.ezekiel20.online

# 2. The S3 bucket you created for Kops state (e.g., s3://my-kops-state-123)
STATE_STORE=taskapp-ezekiel-kops-state

# 3. Your AWS Region
AWS_REGION=eu-west-1

# 4. Your VPC ID
VPC_ID=vpc-012b130a81350b79e

# 5. Your private subnets (comma-seperated)
PRIVATE_SUBNETS=subnet-031390d9954634d4a,subnet-084bae3da21ede1ec,subnet-037f789f4ab8045c7

# 6. Your public subnets (comma-seperated)
PUBLIC_SUBNETS=subnet-0fe7656c7c1df4846,subnet-003b7c641af103508,subnet-0757bfcf52f6f1d3b

echo "Make sure you edit all the required variables before running this script"
echo "Variables are denoted with <>"

sleep 30s

cd ..

cd kops

echo ""

#kOps CLI configuration for yaml
echo "Creating kOps cluster yaml file with all neccesary flags"
kops create cluster  --name=${NAME} --state=s3://${STATE_STORE} --network-id=${VPC_ID} --subnets=${PRIVATE_SUBNETS} --utility-subnets=${PUBLIC_SUBNETS} --zones=${AWS_REGION}a,${AWS_REGION}b,${AWS_REGION}c --ssh-public-key=~/.ssh/id_rsa_kops.pub --control-plane-zones=${AWS_REGION}a,${AWS_REGION}b,${AWS_REGION}c --topology=private --networking=calico --set="spec.serviceAccountIssuerDiscovery.discoveryStore=s3://${STATE_STORE}/${NAME}/discovery" --set="spec.iam.useServiceAccountExternalPermissions=true" --set="spec.serviceAccountIssuerDiscovery.enableAWSOIDCProvider=true" --control-plane-count=3 --node-count=3 --node-size=t3a.medium --control-plane-size=t3a.medium --dns-zone=${NAME} --bastion="true" --dry-run -o yaml > cluster-config.yaml

echo ""

echo "Editing kOps cluster yaml for spot instances pricing"
vi cluster-config.yaml
