# week-37.1-horizontal-pod-node-autoscaler
[Lecture Notes](https://projects.100xdevs.com/tracks/kubernetes-3/Kubernetes-Part-3--Scaling--1)

### This project is a simple Node.js application that demonstrates horizontal pod autoscaling using Kubernetes.


# 🚀 Horizontal Pod Autoscaler — Kubernetes CPU Autoscaling Demo  
**Tags:** `kubernetes` `hpa` `autoscaling` `devops` `nodejs` `metrics` `cpu`  

This project demonstrates **Horizontal Pod Autoscaling (HPA)** in Kubernetes using CPU utilization as the scaling metric.  
It includes a **Deployment**, **Service**, and **HorizontalPodAutoscaler** that work together to scale pods automatically when CPU usage increases.

---

## 📦 Project Overview  
This is a simple Node.js application packaged as a Docker image and deployed on Kubernetes.  
The app runs on port **3000** and is exposed externally through a **LoadBalancer Service**.  
The **HPA controller** watches CPU usage and adjusts the number of replicas automatically.

---

## 📁 Files Included  
- `deployment.yml` — Contains Deployment, Service, and HPA resources  
- Node.js application created using Bun (`bun init`, Bun v1.3.1)

---

## 🧠 Concepts Explained (Based on `deployment.yml`)

### 1️⃣ **Deployment**
Deployment manages running instances (pods) of your application.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-deployment
```

#### Key Concepts:

### 🔹 **replicas: 3**
Kubernetes starts **3 pods** initially.

### 🔹 **selector & labels**
```yaml
selector:
  matchLabels:
    app: cpu-app
```
Selectors match pods using labels.  
Only pods with label `app: cpu-app` belong to this Deployment.

### 🔹 **container configuration**
```yaml
image: 100xdevs/week-28:latest
ports:
  - containerPort: 3000
```
The Node.js app runs on port `3000`, inside container `cpu-app`.

### 🔹 **resource requests & limits**
```yaml
resources:
  requests:
    cpu: 500m
  limits:
    cpu: 1000m
```
- **requests.cpu = 500m → 0.5 CPU core guaranteed**  
- **limits.cpu = 1000m → max 1 CPU core allowed**  
- This ensures predictable scheduling and prevents resource overuse.

---

## 2️⃣ **Service (LoadBalancer)**  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: cpu-service
```

### 🔹 **selector**
```yaml
selector:
  app: cpu-app
```
Targets pods created by the Deployment.

### 🔹 **ports**
```yaml
port: 80
targetPort: 3000
```
- Users access the app on port **80**
- Traffic goes internally to pod port **3000**

### 🔹 **type: LoadBalancer**
Creates an external IP for global access (on cloud or minikube tunnel).

---

## 3️⃣ **HorizontalPodAutoscaler (HPA)**  
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cpu-hpa
```

### 🔹 **scaleTargetRef**
Links HPA with the Deployment:
```yaml
scaleTargetRef:
  apiVersion: apps/v1
  kind: Deployment
  name: cpu-deployment
```

### 🔹 **Replica range**
```yaml
minReplicas: 2
maxReplicas: 20
```
Pods scale between **2 and 20**, based on CPU load.

### 🔹 **CPU Utilization Metric**
```yaml
metrics:
- type: Resource
  resource:
    name: cpu
    target:
      type: Utilization
      averageUtilization: 50
```

HPA goals:
- If **CPU usage > 50%** → scale **up**
- If **CPU usage < 50%** → scale **down**

Internally, it uses the formula:  
```
desiredReplicas = currentReplicas × currentCPU / targetCPU
```

---

## ▶️ Running the Node App

### Install dependencies:
```bash
bun install
```

### Run locally:
```bash
bun run index.ts
```

---

## 🚀 Apply Kubernetes Manifests

### Deploy everything:
```bash
kubectl apply -f deployment.yml
```

### View pods:
```bash
kubectl get pods
```

### View HPA:
```bash
kubectl get hpa
```

### Check live CPU usage:
```bash
kubectl top pods
```

---

## 📌 How Autoscaling Works (Simple Explanation)

1. Each pod reports CPU usage to Kubernetes Metrics Server  
2. HPA checks usage every 15 seconds  
3. If CPU > 50%, HPA adds more pods  
4. If CPU < 50%, HPA removes pods  
5. The goal is to keep the average CPU around the target

---

## ❤️ Credits
Created as part of the **100xDevs Kubernetes Week**.  
This README explains the full architecture behind the autoscaling setup.