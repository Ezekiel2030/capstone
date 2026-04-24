#!/bin/bash

USERNAME=$(aws sts get-caller-identity --query Arn --output text | cut -d '/' -f 2)
# Add Permissions for full kOps utilisation on AWS CLI

echo ""

echo "Creating kops group"
aws iam create-group --group-name kops

echo ""

echo "Attach required policies to kops group"
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess --group-name kops

echo ""

echo "Add existing user to kops group"
aws iam add-user-to-group --user-name ${USERNAME} --group-name kops
