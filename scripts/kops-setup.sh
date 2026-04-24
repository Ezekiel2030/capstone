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
VPC_ID=vpc-01d27554519c663ce

# 5. Your private subnets (comma-seperated)
PRIVATE_SUBNETS=subnet-0e2b4153f1e9fa1d1,subnet-0d0f452379f3fc6cd,subnet-06ce847c793edd99e

# 6. Your public subnets (comma-seperated)
PUBLIC_SUBNETS=subnet-0dd1404d4ebc396c3,subnet-044b3872ade5f47e1,subnet-0534cb11aa79d50ed

echo "Make sure you edit all the required variables before running this script"
echo "Variables are denoted with <>"

sleep 30s

cd ..

cd kops

echo ""

#kOps CLI configuration for yaml
echo "Creating kOps cluster yaml file with all neccesary flags"
kops create cluster  --name=${NAME} --state=s3://${STATE_STORE} --network-id=${VPC_ID} --subnets=${PRIVATE_SUBNETS} --utility-subnets=${PUBLIC_SUBNETS} --zones=${AWS_REGION}a,${AWS_REGION}b,${AWS_REGION}c --ssh-public-key=~/.ssh/id_rsa_kops.pub --control-plane-zones=${AWS_REGION}a,${AWS_REGION}b,${AWS_REGION}c --topology=private --networking=cilium --set="spec.serviceAccountIssuerDiscovery.discoveryStore=s3://${STATE_STORE}/${NAME}/discovery" --set="spec.iam.useServiceAccountExternalPermissions=true" --set="spec.serviceAccountIssuerDiscovery.enableAWSOIDCProvider=true" --control-plane-count=3 --node-count=3 --node-size=t3a.medium --control-plane-size=t3a.medium --dns-zone=${NAME} --bastion="true" --dry-run -o yaml > cluster-config.yaml

echo ""

echo "Editing kOps cluster yaml for spot instances pricing"
vi cluster-config.yaml
