# Scaling Node.js with Kubernetes on AWS

🚀 This repository contains a **high-performance, scalable** Node.js setup on AWS Kubernetes (EKS), designed to handle **over 1 million requests per second**.

## 📂 Features
- High-performance **Fastify**-based Node.js API
- Autoscaling with **HPA, Cluster Autoscaler & KEDA**
- AWS Load Balancer (ALB) + **NGINX/Traefik**
- Database scaling with **PostgreSQL (RDS) + Redis caching**
- Monitoring using **Prometheus, Grafana, Jaeger**
- **Step-by-step AWS EKS deployment guide** using `Terraform` & `eksctl`
- Unit tests for the worker execution with **Jest**

## 📂 Project Structure
```
📦 scaling-nodejs-kubernetes
├── 📜 index.js                 # Main entry point (calls server.js)
├── 📂 src/                     # High-performance Node.js API
│   ├── server.js               # Fastify API server with clustering
│   ├── worker.js               # Worker threads implementation
│   ├── database.js             # PostgreSQL connection pooling
│   ├── cache.js                # Redis setup
│   ├── config.js               # Environment variables
├── 📂 k8s/                     # Kubernetes configuration files
│   ├── deployment.yaml         # Deployment for Node.js app
│   ├── service.yaml            # Kubernetes service definition
│   ├── ingress.yaml            # Ingress controller setup
│   ├── hpa.yaml                # Horizontal Pod Autoscaler
│   ├── cluster-autoscaler.yaml # EKS Cluster Autoscaler
│   ├── keda.yaml               # KEDA Event-driven scaling
├── 📂 aws/                     # AWS-specific deployment guides
│   ├── eks-setup.md            # Guide to setting up an EKS cluster
│   ├── terraform-eks.tf        # Terraform script for EKS provisioning
│   ├── eks-load-balancer.yaml  # AWS Load Balancer Controller setup
├── 📂 monitoring/              # Observability stack
│   ├── prometheus-config.yaml  # Prometheus setup
│   ├── grafana-dashboard.json  # Grafana visualization config
│   ├── jaeger-tracing.yaml     # Jaeger for distributed tracing
├── 📂 tests/                   # Unit tests
│   ├── worker.test.js          # Worker unit tests
├── 📜 README.md                # Documentation
├── 📜 setup.sh                 # Script to install dependencies
├── 📜 Dockerfile               # Container setup
├── 📜 .dockerignore            # Ignore unnecessary files
├── 📜 .gitignore               # Ignore node_modules, logs, etc.
├── 📜 LICENSE                  # Open-source license
```

## 🚀 Installation Guide

**You can achieve this by simply executing the `setup.sh` file.** or doing it manually as explained below:

### **1️⃣ Install System Dependencies**

Before setting up the environment, install **Docker, Kubernetes (`kubectl`), and Minikube**.

#### **Install Docker (Required)**
```sh
# MacOS (Homebrew)
brew install --cask docker
open /Applications/Docker.app  # Ensure Docker is running

# Ubuntu/Debian
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Verify Installation
docker --version
```

#### **Install Kubernetes CLI (`kubectl`)**
```sh
# MacOS
brew install kubectl

# Ubuntu/Debian
sudo apt update
sudo apt install -y kubectl
```
Verify:
```sh
kubectl version --client
```

#### **Install Minikube (For Local Kubernetes)**
```sh
# MacOS (Homebrew)
brew install minikube
minikube start

# Ubuntu/Debian
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
```

Verify Kubernetes Cluster:
```sh
kubectl cluster-info
```
Expected output:
```
Kubernetes master is running at https://192.168.xxx.xxx
```

### **2️⃣ Install Node.js Dependencies**
Ensure you have **Node.js 18+** installed, then install dependencies:
```sh
npm install
```

### **3️⃣ Install PostgreSQL**
PostgreSQL is required for the database.

#### **MacOS (Homebrew)**
```sh
brew install postgresql
brew services start postgresql
```

#### **Ubuntu/Debian**
```sh
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

#### **Windows**
Download from [PostgreSQL Official Site](https://www.postgresql.org/download/).

Create the database:
```sh
psql -U postgres
CREATE DATABASE node_scaling;
```
Verify:
```sh
psql -U postgres -d node_scaling
```

### **4️⃣ Install & Start Redis**
#### **MacOS (Homebrew)**
```sh
brew install redis
brew services start redis
```

#### **Ubuntu/Debian**
```sh
sudo apt update
sudo apt install redis-server
sudo systemctl start redis
```

Verify Redis is Running:
```sh
redis-cli ping
```
Expected output:
```
PONG
```

### **5️⃣ Configure Environment Variables**
Create a `.env` file:
```sh
DB_HOST=127.0.0.1
DB_USER=postgres
DB_PASS=password
DB_NAME=node_scaling
DB_PORT=5432
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

### **6️⃣ Run the API Locally**
Start the Fastify API without Docker:
```sh
npm start
```

To run inside a Docker container:
```sh
docker build -t scaling-nodejs-k8s .
docker run -p 3000:3000 --env-file .env scaling-nodejs-k8s
```

## **🔥 AWS EKS Deployment Guide**
Install **Terraform & `eksctl`** for AWS EKS.

#### **1️⃣ Install Terraform**
```sh
brew install terraform  # MacOS
sudo apt install terraform -y  # Ubuntu/Debian
```

#### **2️⃣ Install `eksctl` (AWS EKS CLI)**
```sh
brew install eksctl  # MacOS
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /usr/local/bin  # Linux
```

#### **3️⃣ Deploy to AWS EKS**
```sh
aws eks update-kubeconfig --region us-east-1 --name my-cluster
kubectl apply -f k8s/
```

## **🛠 Troubleshooting**
### **🔴 PostgreSQL Errors**
Fix missing users, databases, or connection issues.

### **🔴 Redis Errors**
Ensure Redis is installed and running.

### **🔴 Kubernetes Issues**
Check `kubectl get pods` and `kubectl logs`.

## 🧪 Unit Tests
To run the unit tests, execute the following command:
```sh
npm test
```

## 💥 Issues
If you encounter any issues, please [open an issue](https://github.com/felipekm/scaling-nodejs-kubernetes/issues) on GitHub.

## **📚 Resources*
  * [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
  * [Jest](https://jestjs.io)
  * [KEDA](https://keda.sh/)
  * [Redis](https://redis.io/)
  * [NGINX](https://www.nginx.com/)
  * [Jaeger](https://www.jaegertracing.io/)
  * [Docker](https://www.docker.com/)
  * [Fastify](https://www.fastify.io/)
  * [Traefik](https://traefik.io/)
  * [EKSCTL](https://eksctl.io/)
  * [Grafana](https://grafana.com/)
  * [Minikube](https://minikube.sigs.k8s.io/)
  * [AWS EKS](https://aws.amazon.com/eks/)
  * [Terraform](https://www.terraform.io/)
  * [Kubernetes](https://kubernetes.io/)
  * [Prometheus](https://prometheus.io/)
  * [PostgreSQL](https://www.postgresql.org/)

## **📜 License**
Licensed under the **MIT License** - see [LICENSE](LICENSE) for details.
