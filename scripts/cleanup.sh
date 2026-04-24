#!/bin/bash

set -euo pipefail

export NAME=clusters.ezekiel20.online
STATE_STORE=taskapp-ezekiel-kops-state
export KOPS_STATE_STORE=s3://${STATE_STORE}

echo "Make sure you edit all the required variables before running this script"
echo "Variables are denoted with <>"

sleep 30s

echo ""

cd .. 

cd kops/terraform_route53

echo "Removing Roue53 CNAME Propagation"
echo "Make sure you have the External IP of the ingress controller"
sleep 30s
terraform destroy

echo ""

cd ..

cd terraform_rds

 echo "You need to re-input your project name"
 echo "Make sure you have your database password ready"
 echo "VPC ID is required"
 echo "Private subnet ids are required in a list of strings"
 echo "AWS region is required"
 echo "Cluster name is required"
 echo "Account ID is required"
 echo "Kops bucket name is required"
sleep 30s
terraform destroy

echo ""

cd ..

echo "Deleting Kops Cluster"
kops delete cluster --name ${NAME} --yes

echo ""

cd ..

cd terraform/root

echo "Deleting kops bucket"
echo "Press q when you see the : prompt"
aws s3api delete-objects \
    --bucket ${STATE_STORE} \
    --delete "$(aws s3api list-object-versions \
    --bucket ${STATE_STORE} \
    --output json \
    --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

aws s3api delete-objects \
    --bucket ${STATE_STORE} \
    --delete "$(aws s3api list-object-versions \
    --bucket ${STATE_STORE} \
    --output json \
    --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"

echo ""

echo "Destroying infrastructure"
echo "State locking will be ignored"
terraform destroy -lock=false

echo ""

echo "Removing AWS Secrets"
aws secretsmanager delete-secret --secret-id project/capstone/database_credentials --force-delete-without-recovery
