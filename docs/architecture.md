# Architecture Documentation

## System Architecture Overview

TeamFlow is a full-stack web application following a microservices architecture deployed on AWS using Kubernetes. The system is designed for scalability, security, and maintainability.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                              │
│  React SPA (Vite) - Tailwind CSS - React Router              │
│  Running on NGINX in Kubernetes                              │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTPS (TLS via Let's Encrypt)
                     │
┌────────────────────▼────────────────────────────────────────┐
│              KUBERNETES CLUSTER (kOps)                        │
│  - 3 Control Plane nodes (t3a.medium)                         │
│  - 3 Worker nodes (t3a.medium)                                │
│  - Networking: Calico                                         │
│  - RBAC & IRSA (IAM Roles for Service Accounts)               │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
   ┌────▼───┐   ┌────▼───┐   ┌──▼─────┐
   │Frontend │   │Backend │   │Secrets │
   │Pod (×3) │   │Pod (×3)│   │Provider│
   └────┬───┘   └────┬───┘   └──┬─────┘
        │            │           │
        └────────────┼───────────┤
                     │           │
                  HTTP/1.1     Mount
                     │           │
        ┌────────────┴───────────┘
        │
   ┌────▼──────────────────┐
   │   AWS Secrets Manager  │
   │ (Database Credentials) │
   └────┬──────────────────┘
        │
   ┌────▼──────────────────┐
   │ AWS RDS PostgreSQL     │
   │ - Allocated: 20GB      │
   │ - Max: 100GB (auto)    │
   └───────────────────────┘
```

## Component Details

### Frontend Service

**Technology Stack:**
- React 18.3.1 with TypeScript
- Vite for build tooling
- Tailwind CSS for styling
- React Router for client-side routing

**Responsibilities:**
- User interface and user experience
- Client-side routing and navigation
- API communication with backend
- Authentication state management
- Form validation and error handling

**Key Components:**
- `App.tsx`: Main application component
- `AuthContext.tsx`: Global authentication state
- `KanbanColumn.tsx`: Task column display
- `TaskCard.tsx`: Individual task display
- `TaskForm.tsx`: Task creation/editing form
- `ProtectedRoute.tsx`: Route protection wrapper

**Deployment:**
- Containerized with multi-stage Docker build
- Served by NGINX in Kubernetes pods
- 3 replicas for high availability
- Static file serving with SPA routing support

### Backend Service

**Technology Stack:**
- Python 3.11 with Flask 3.0.0
- SQLAlchemy ORM
- PostgreSQL database
- JWT for authentication
- Gunicorn WSGI server

**Responsibilities:**
- Business logic implementation
- API endpoint handling
- Database operations
- Authentication and authorization
- Input validation and sanitization

**Key Modules:**
- `models.py`: Database models (User, Task)
- `routes.py`: API route definitions
- `auth.py`: Authentication logic
- `__init__.py`: Application factory

**Deployment:**
- Containerized Python application
- 3 replicas with load balancing
- Health checks for liveness and readiness
- Environment-based configuration

### Database Layer

**Technology:**
- AWS RDS PostgreSQL
- Instance class: db.t3.micro
- Storage: 20GB allocated, auto-scaling to 100GB

**Features:**
- Relational data storage
- ACID transactions
- Connection pooling via SQLAlchemy
- Automated backups (disabled for cost optimization)
- VPC-only access for security

### Infrastructure Layer

**Kubernetes Cluster:**
- Managed by kOps on AWS
- 3 control plane nodes (t3a.medium)
- 3 worker nodes (t3a.medium)
- Calico networking plugin
- RBAC enabled
- IRSA for pod IAM access

**Networking:**
- VPC with public and private subnets
- Internet Gateway for public access
- NAT Gateway for private subnet outbound traffic
- Security groups for service isolation

**Security:**
- AWS Secrets Manager for database credentials
- CSI driver for secrets injection
- Let's Encrypt SSL certificates
- JWT-based API authentication

## Data Flow

1. **User Registration/Login:**
   - User submits credentials via frontend form
   - Frontend calls `/api/auth/login` or `/api/auth/register`
   - Backend validates credentials against database
   - JWT token generated and returned
   - Frontend stores token in localStorage

2. **Task Operations:**
   - Authenticated requests include Bearer token
   - Backend validates JWT on protected routes
   - Database queries executed via SQLAlchemy
   - JSON responses returned to frontend
   - UI updates reactively

3. **Health Monitoring:**
   - Kubernetes probes `/api/health` endpoint
   - Load balancer distributes traffic
   - Automatic pod restarts on failures

## Security Considerations

- **Authentication:** JWT tokens with expiration
- **Authorization:** Route-level protection decorators
- **Data Protection:** HTTPS everywhere via TLS
- **Secrets Management:** AWS Secrets Manager integration
- **Network Security:** VPC isolation, security groups
- **Container Security:** Non-root user execution

## Scalability Features

- **Horizontal Scaling:** Multiple pod replicas
- **Load Balancing:** Kubernetes service distribution
- **Database Scaling:** RDS storage auto-scaling
- **Caching:** (Not implemented - potential future enhancement)
- **CDN:** (Not implemented - potential future enhancement)

## Monitoring and Observability

- **Health Checks:** Liveness and readiness probes
- **Logging:** Container logs via Kubernetes
- **Metrics:** (Not implemented - potential future enhancement)
- **Cost Monitoring:** AWS Budget alerts configured

## Deployment Architecture

The application uses GitOps-style deployment with:

- **Infrastructure as Code:** Terraform for AWS resources
- **Cluster Management:** kOps for Kubernetes provisioning
- **Application Deployment:** Kubernetes manifests
- **Automated SSL:** cert-manager with Let's Encrypt
- **DNS Management:** Route53 for domain routing

This architecture provides a production-ready, scalable, and maintainable solution for task management with enterprise-grade security and reliability features.