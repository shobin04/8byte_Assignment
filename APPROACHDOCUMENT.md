Comprehensive Approach Documentation

## 1. Executive Summary
This section outlines the technical design, automation strategy, and operational workflows implemented across the four primary phases of the project: Infrastructure Provisioning, Deployment Automation, Monitoring/Logging Setup, and Security & Best Practices.

---

## 2. Phase Breakdown & Design Choices

### Part 1: Infrastructure Provisioning (Terraform)
* Network Topology: Configured a custom VPC with 2 Public Subnets (across different Availability Zones for High Availability) and 2 Private Subnets.
* Compute Layer: An AWS EC2 t3.micro instance running Amazon Linux 2 / Ubuntu serves as the primary Docker engine host for application environments and the observability suite.
* Database Layer: Provisioned an AWS RDS PostgreSQL instance in private subnets. Security Groups enforce inbound database traffic exclusively from the EC2 instance Security Group on port 5432.

### Part 2: Deployment Automation (GitHub Actions)
The CI/CD pipeline (.github/workflows/deploy.yml) is split into logical stages to balance agility and release stability:
1. Pull Request Stage: Triggers on PR creation against main. Installs dependencies, runs test suites, scans Node dependencies (npm audit), and scans Docker container builds (Trivy).
2. Build & Push Stage: Executes upon merging to main. Builds the application image and tags it with both :latest and the unique git commit SHA, then pushes to Docker Hub.
3. Staging Deployment: Automatically updates and restarts the Staging container running on port 3001.
4. Manual Production Gate: Utilizes GitHub Action Environments (production) to enforce a human review step. Once approved, the job updates the Production container on port 3000.

### Part 3: Observability Architecture (Prometheus, Loki, Grafana)
* Metrics Ingestion: Prometheus pulls host-level system metrics from node-exporter (port 9100) and custom application metrics (request counter, DB status gauge, active pool count) from the Node.js application /metrics endpoint.
* Log Aggregation: Promtail mounts /var/run/docker.sock directly on the host, extracts container output streams, tags them with container names, and forwards them to Loki on port 3100.
* Dashboard Visualization: Built two main dashboards in Grafana:
  * Host Infrastructure & System Metrics: Real-time CPU usage, RAM utilization, Disk I/O, App Request Rates, and RDS Database Connectivity Health.
  * Centralized Container Logs: Unified log stream allowing real-time LogQL filtering across production, staging, and system containers.

### Part 4: Secret Management & Backup Strategy
* Secret Management: AWS Secrets Manager stores database credentials. The EC2 instance retrieves credentials securely during application startup using AWS IAM Roles and environment variables, avoiding stored credentials in code.
* RDS Backup Strategy: Enabled automated daily RDS snapshots with a 7-day retention period, along with Point-In-Time Restore (PITR) capabilities to ensure zero data loss during failure events.

---
---
