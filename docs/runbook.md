# Deployment Runbook

This runbook provides step-by-step instructions for deploying the TeamFlow application to AWS using Kubernetes and infrastructure as code tools.

## Prerequisites

Before starting deployment, ensure you have:

- AWS CLI configured with appropriate permissions
- Terraform 1.0+
- kOps installed
- kubectl installed
- Docker (for local testing)
- Domain name configured in Route53 (clusters.ezekiel20.online)
- SSH key pair for cluster access

## Infrastructure Setup Sequence

### 1. AWS Infrastructure Setup

**Initialize Terraform:**
```bash
cd terraform/root
terraform init
```

**Review and apply infrastructure:**
```bash
terraform plan
terraform apply
```

This creates:
- VPC with public/private subnets across 3 AZs
- Internet Gateway and NAT Gateway
- S3 buckets for Terraform and kOps state
- DynamoDB table for Terraform locks
- AWS Budget alerts

### 2. Kubernetes Cluster Setup

**Configure kOps:**
```bash
cd kops
export KOPS_STATE_STORE=s3://taskapp-ezekiel-kops-state
```

**Create cluster:**
```bash
kops create -f cluster-config.yaml
kops create secret --name clusters.ezekiel20.online sshpublickey admin < ~/.ssh/id_rsa.pub
kops update cluster --name clusters.ezekiel20.online --yes
```

**Wait for cluster to be ready:**
```bash
kops validate cluster --wait 10m
```

**Configure kubectl:**
```bash
kops export kubecfg --name clusters.ezekiel20.online
kubectl get nodes
```

### 3. Database Setup

**Initialize RDS Terraform:**
```bash
cd kops/terraform_rds
terraform init
```

**Apply database infrastructure:**
```bash
terraform plan
terraform apply
```

This creates:
- PostgreSQL RDS instance (db.t3.micro)
- Database subnet group
- Security group for database access
- Stores credentials in AWS Secrets Manager

### 4. Application Deployment

**Deploy cert-manager for SSL:**
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
```

**Wait for cert-manager to be ready:**
```bash
kubectl wait --for=condition=available --timeout=300s deployment -n cert-manager --all
```

**Deploy application manifests:**
```bash
cd k8s
kubectl apply -f cluster-issuer.yaml
kubectl apply -f service-account.yaml
kubectl apply -f secretProviderClass.yaml
kubectl apply -f backendDeployment.yaml
kubectl apply -f frontendDeployment.yaml
kubectl apply -f routing.yaml
```

**Wait for deployments to be ready:**
```bash
kubectl wait --for=condition=available --timeout=300s deployment/taskapp-backend
kubectl wait --for=condition=available --timeout=300s deployment/taskapp-frontend
```

### 5. DNS Configuration

**Update Route53 records:**
```bash
cd kops/terraform_route53
terraform init
terraform plan
terraform apply
```

This creates CNAME records pointing to the Ingress load balancer.

## Verification Steps

### Check Cluster Status
```bash
kubectl get nodes
kubectl get pods -A
kubectl get services
kubectl get ingress
```

### Verify SSL Certificates
```bash
kubectl get certificates
kubectl describe certificate taskapp-tls
```

### Test Application Access
- Frontend: https://taskapp.ezekiel20.online
- Backend API: https://api.ezekiel20.online
- Health check: https://api.ezekiel20.online/api/health

### Database Connectivity
```bash
kubectl exec -it deployment/taskapp-backend -- python -c "
import os
import psycopg2
conn = psycopg2.connect(
    host=os.environ['DATABASE_HOST'],
    port=os.environ['DATABASE_PORT'],
    dbname=os.environ['DATABASE_NAME'],
    user=os.environ['DATABASE_USER'],
    password=os.environ['DATABASE_PASSWORD']
)
print('Database connection successful')
conn.close()
"
```

## Troubleshooting

### Common Issues

**Cluster not ready:**
```bash
kops validate cluster
kubectl get events --sort-by=.metadata.creationTimestamp
```

**Pods not starting:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**SSL certificate pending:**
```bash
kubectl describe certificate taskapp-tls
kubectl get challenges
```

**Database connection issues:**
```bash
kubectl exec -it deployment/taskapp-backend -- env | grep DATABASE
kubectl describe secretproviderclass aws-secretsmanager
```

### Logs and Debugging

**Application logs:**
```bash
kubectl logs -f deployment/taskapp-backend
kubectl logs -f deployment/taskapp-frontend
```

**Ingress controller logs:**
```bash
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

**Cert-manager logs:**
```bash
kubectl logs -n cert-manager deployment/cert-manager
```

## Scaling Operations

### Scale application replicas:
```bash
kubectl scale deployment taskapp-backend --replicas=5
kubectl scale deployment taskapp-frontend --replicas=5
```

### Update application images:
```bash
kubectl set image deployment/taskapp-backend taskapp-backend=your-registry/taskapp-backend:v2.0
kubectl set image deployment/taskapp-frontend taskapp-frontend=your-registry/taskapp-frontend:v2.0
kubectl rollout status deployment/taskapp-backend
kubectl rollout status deployment/taskapp-frontend
```

## Backup and Recovery

### Database backup (manual):
```bash
aws rds create-db-snapshot --db-instance-identifier taskapp-ezekiel-postgres --db-snapshot-identifier manual-backup-$(date +%Y%m%d-%H%M%S)
```

### Cluster backup:
```bash
kops get cluster -o yaml > cluster-backup.yaml
```

## Cleanup Procedure

**Warning: This will destroy all resources and data**

```bash
cd scripts
./cleanup.sh
```

The cleanup script performs:
1. Destroy Route53 records
2. Destroy RDS database
3. Delete kOps cluster
4. Remove S3 buckets and Terraform state

## Monitoring and Maintenance

### Health Checks
- Kubernetes probes automatically restart unhealthy pods
- AWS Budget alerts notify when costs exceed thresholds
- SSL certificates auto-renew via cert-manager

### Updates
- Regularly update kOps cluster: `kops upgrade cluster --yes`
- Update Kubernetes version: `kops update cluster --yes`
- Monitor AWS console for service updates

### Cost Optimization
- Monitor resource usage in AWS console
- Scale down when not in use
- Use spot instances for development environments
- Clean up unused resources regularly

## Security Considerations

- Rotate database credentials regularly
- Keep SSH keys secure and rotate periodically
- Monitor AWS CloudTrail for suspicious activity
- Regularly update base images and dependencies
- Use principle of least privilege for IAM roles

## Performance Tuning

### Database
- Monitor query performance with RDS Performance Insights
- Consider read replicas for high-traffic scenarios
- Optimize SQLAlchemy queries

### Application
- Implement caching (Redis) for session data
- Use CDN for static assets
- Monitor pod resource usage and adjust requests/limits

### Infrastructure
- Use cluster autoscaling for variable workloads
- Implement horizontal pod autoscaling
- Monitor network latency and throughput