# AWS End-to-End Containerized Infrastructure, CI/CD & Observability Stack

This repository contains an end-to-end, production-grade DevOps deployment for a Node.js web application connected to an AWS RDS PostgreSQL database. The setup features automated infrastructure provisioning with Terraform, automated deployment pipelines via GitHub Actions, and centralized observability using Prometheus, Grafana, Promtail, and Loki.

---

## 🏗️ Architecture Overview

* **Cloud Provider**: AWS (VPC, EC2, RDS PostgreSQL, Security Groups)
* **Application Layer**: Node.js Express Application containerized with Docker (Staging on Port 3001, Production on Port 3000)
* **Database Layer**: AWS RDS PostgreSQL Instance (Accessible only from EC2 via Security Groups)
* **Monitoring & Metrics**: Prometheus (Scraping `node-exporter` on port 9100 and Node.js app on port 3000/3001)
* **Visualization**: Grafana (Host Infrastructure & Application Dashboards)
* **Centralized Logging**: Promtail (Docker log collection via `/var/run/docker.sock`) -> Loki (Log aggregation engine)
* **CI/CD Pipeline**: GitHub Actions (PR testing, Trivy container scanning, Docker Hub image push, Staging deployment, manual approval gate, Production deployment)

---

## 🚀 Infrastructure Setup & Deployment Instructions

### Prerequisites
* AWS CLI configured with administrator access credentials.
* Terraform (`>= 1.15.0`) installed locally.
* Git and Docker installed.

### Step 1: Provision Infrastructure with Terraform
Goto terraform project folder

terraform init
terraform validate
terraform plan
terraform apply -auto-approve

Step 2: Configure Environment & Secrets
Store the following secrets in your AWS Secrets Manager or GitHub Repository Secrets:

DB_HOST: Your RDS PostgreSQL endpoint domain.
DB_USER: Database master username (postgres).
DB_PASSWORD: Database master password.
DB_NAME: Target database name (postgres).
EC2_HOST: EC2 Public IP address.
EC2_SSH_KEY: Content of your EC2 .pem private SSH key.
DOCKER_USERNAME / DOCKER_PASSWORD: Docker Hub credentials.

Step 3: Run Observability Stack on EC2
SSH into your EC2 instance and clone the monitoring setup:
ssh -i "your-key.pem" ec2-user@<EC2_PUBLIC_IP>
git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
cd your-repo

# Start Prometheus, Grafana, Loki, Promtail, Node Exporter
docker compose up -d

Key Architectural Decisions
Host-Gateway Docker Networking for Scraping (172.17.0.1):
Instead of hardcoding private IP addresses inside Docker containers, Prometheus and Promtail communicate with the host application containers on ports 3000/3001 via the default Docker bridge host gateway (172.17.0.1). This prevents container IP drift across reboots.

Custom Database Metrics Instrumentation:
Rather than running an extra postgres-exporter container, database health (db_connection_status) and connection pool numbers (db_active_connections) are exposed directly from the Node.js application /metrics endpoint using prom-client. This reduces resource overhead on single-instance EC2 deployments.

Staging vs. Production Environment Isolation on Single EC2:
Staging (port 3001) and Production (port 3000) run as isolated container instances on the same host, allowing zero-downtime blue/green style rollouts without doubling infrastructure costs during early project phases.

## 🔐 Security Considerations

* **Secure Terraform State Management (S3 + DynamoDB)**: 
  Infrastructure state is stored remotely in an **AWS S3 bucket** configured with AES-256 server-side encryption and versioning enabled to prevent state file tampering or unauthorized exposure. State locking is enforced using an **AWS DynamoDB table** to prevent concurrent execution conflicts, race conditions, and accidental state corruption.

* **VPC & Network Isolation**: 
  RDS PostgreSQL is placed in private subnets. Security Groups enforce strict least-privilege rules, restricting inbound traffic on port `5432` exclusively to requests originating from the EC2 Instance Security Group ID.

* **Secret Management via AWS Secrets Manager**: 
  Database credentials and sensitive parameters are retrieved dynamically at runtime using AWS Secrets Manager rather than being hardcoded in application code or stored in version control.

* **Vulnerability & Container Scanning in CI/CD**: 
  Every pull request automatically triggers dependency security audits (`npm audit`) and container filesystem vulnerability scans (`aquasecurity/trivy-action`) to detect and block vulnerable images prior to deployment.

* **EC2 Access Control**: 
  EC2 instance SSH access is locked down using SSH key-pair authentication, with direct root login disabled.

**Cost Optimization Measures**
Single-Instance EC2 for Monitoring Stack: Prometheus, Loki, Grafana, Node Exporter, and Promtail run lightweight Docker containers co-located on the EC2 host, eliminating the cost of managed services like AWS CloudWatch Custom Metrics or Amazon Managed Grafana.

Minimal Scrape Frequency: Configured scrape_interval: 15s in Prometheus and batching in Promtail to keep CPU consumption low and avoid disk I/O bottlenecks.

RDS Instance Sizing & Retention: Provisioned a db.t3.micro instance with storage autoscaling disabled for non-production workloads, significantly reducing idle hourly runtime charges.









