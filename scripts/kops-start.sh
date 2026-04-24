#!/bin/bash

set -euo pipefail

export NAME=clusters.ezekiel20.online
STATE_STORE=taskapp-ezekiel-kops-state
export KOPS_STATE_STORE=s3://${STATE_STORE}

echo "Make sure you edit all the required variables before running this script"
echo "Variables are denoted with <>"

sleep 30s

cd ..

cd kops
# kOps cluster initialisation

echo "Adding cluster configuration to bucket and provisioning"
kops create -f cluster-config.yaml

echo ""

echo "Creating cluster"
kops update cluster --name ${NAME} --yes --admin
sleep 30s

echo ""

echo "Starting Cluster Validation"
kops validate cluster --wait 15m

echo ""

echo "Showing nodes"
kubectl get nodes -o wide
