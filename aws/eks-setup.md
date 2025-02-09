# AWS EKS Setup Guide

This guide walks you through setting up **Amazon EKS (Elastic Kubernetes Service)** for deploying the **Fastify API**.

---

## 🚀 Prerequisites

Ensure you have the following installed:
- **AWS CLI** (`aws configure` should be set up)
- **eksctl** (EKS command-line tool)
- **kubectl** (Kubernetes CLI)
- **Terraform** (if using Terraform for infrastructure provisioning)

### **1️⃣ Create an EKS Cluster**
```sh
eksctl create cluster --name fastify-cluster --region us-east-1 --nodegroup-name workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4
```

### **2️⃣ Verify Cluster is Running**
```sh
aws eks update-kubeconfig --region us-east-1 --name fastify-cluster
kubectl get nodes
```

---

## **Deploying Fastify API on AWS EKS**

### **1️⃣ Deploy Application to Kubernetes**
```sh
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml
```

### **2️⃣ Monitor the Deployment**
```sh
kubectl get pods
kubectl get svc
kubectl logs -l app=fastify-api
```

### **3️⃣ Delete the Cluster (if needed)**
```sh
eksctl delete cluster --name fastify-cluster
```
