#!/bin/bash

export DOMAIN=ezekiel20.online

echo "Make sure you edit all the required variables before running this script"
echo "Variables are denoted with <>"

sleep 30s

cd ..

cd kops/terraform_route53

# External IP of ingress controller for route 53

echo "Gettting external IP of ingress controller"

kubectl get svc -n ingress-nginx

echo ""

echo "Copy external IP for the route53 CNAME propagation"

echo ""

echo "Executing route53 CNAME propagation"

terraform init
terraform plan -out=path
terraform apply "path"

echo ""

cd ..

cd ..

cd k8s

echo "Deploying routing manifest to apply ssl certificate"

envsubst '$DOMAIN' < routing.yaml | kubectl apply -f -
