# TeamFlow - Task Management Application

A full-stack Kanban-style task management web application built with modern technologies and deployed on AWS using Kubernetes.

## Overview

TeamFlow is a production-ready task management system that allows users to create, organize, and track tasks through a visual Kanban board interface. The application features user authentication, task CRUD operations, and a responsive design suitable for team collaboration.

## Features

- **User Authentication**: Secure JWT-based login and registration
- **Task Management**: Create, read, update, and delete tasks with priority levels
- **Kanban Board**: Visual organization of tasks across To Do, In Progress, and Done columns
- **Responsive Design**: Mobile-friendly interface built with React and Tailwind CSS
- **RESTful API**: Well-documented backend API with comprehensive testing
- **Production Deployment**: Containerized application deployed on Kubernetes with automated SSL/TLS

## Technology Stack

### Backend
- **Python 3.11** with **Flask 3.0.0**
- **SQLAlchemy** for ORM and database operations
- **PostgreSQL** database with **Alembic** migrations
- **JWT** authentication with **PyJWT**
- **Gunicorn** WSGI server
- **Docker** containerization

### Frontend
- **TypeScript 5.5.3** with **React 18.3.1**
- **Vite 5.4.2** for build tooling
- **Tailwind CSS 3.4.1** for styling
- **React Router v6** for client-side routing
- **Docker** containerization with NGINX

### Infrastructure & DevOps
- **Kubernetes** orchestration via **kOps**
- **AWS** cloud platform (VPC, RDS, Route53, S3, Secrets Manager)
- **Terraform** for infrastructure as code
- **Docker** multi-stage builds
- **NGINX Ingress** with **Let's Encrypt** SSL certificates
- **AWS Secrets Manager** for secure credential management

## Architecture

The application follows a microservices architecture with separate frontend and backend services:

- **Frontend Service**: React SPA served by NGINX, handles user interface and API communication
- **Backend Service**: Flask API server handling business logic, authentication, and database operations
- **Database**: PostgreSQL RDS instance for data persistence
- **Infrastructure**: Kubernetes cluster on AWS with automated scaling and monitoring

For detailed architecture information, see [docs/architecture.md](docs/architecture.md).

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Python 3.11+ (for local development)
- Node.js 18+ (for local development)
- AWS CLI configured (for deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd capstone
   ```

2. **Backend Setup**
   ```bash
   cd src/taskapp_backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   flask db upgrade
   python run.py
   ```

3. **Frontend Setup**
   ```bash
   cd src/taskapp_frontend
   npm install
   npm run dev
   ```

4. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:5000

### Production Deployment

For complete deployment instructions, see [docs/runbook.md](docs/runbook.md).

## Project Structure

```
capstone/
├── src/
│   ├── taskapp_backend/          # Flask API application
│   │   ├── app/                  # Application modules
│   │   ├── migrations/           # Database migrations
│   │   ├── tests/                # Backend tests
│   │   └── requirements.txt      # Python dependencies
│   └── taskapp_frontend/         # React frontend application
│       ├── src/                  # Source code
│       ├── public/               # Static assets
│       └── package.json          # Node dependencies
├── k8s/                          # Kubernetes manifests
├── kops/                         # kOps cluster configuration
├── terraform/                    # Infrastructure as code
├── scripts/                      # Deployment and setup scripts
└── docs/                         # Documentation
```

## API Documentation

### Authentication Endpoints
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user info

### Task Endpoints
- `GET /api/tasks` - List all tasks
- `POST /api/tasks` - Create new task
- `GET /api/tasks/{id}` - Get specific task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task

## Testing

### Backend Tests
```bash
cd src/taskapp_backend
pytest
```

### Frontend Tests
```bash
cd src/taskapp_frontend
npm test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Cost Analysis

For information about the infrastructure costs and budgeting, see [docs/cost-analysis.md](docs/cost-analysis.md).

## License

This project is licensed under the MIT License - see the LICENSE file for details.</content>
<parameter name="filePath">/home/mykaelhunter/Downloads/capstone/README.md