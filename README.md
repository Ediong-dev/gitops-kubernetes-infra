# 🚀 Enterprise GitOps & Cloud-Native Infrastructure Pipeline
### Engineering Track Showcase | KCNA Certified

[![CI/CD Pipeline Status](https://github.com)](https://github.com)

An automated, cloud-native infrastructure showcase demonstrating declarative GitOps workflows, automated application packaging, and localized multi-node container orchestration within resource-constrained server environments.

## 🏗️ Architectural Overview

This project bypasses traditional host-level administrative constraints by deploying an entire staging lifecycle inside a cloud-managed Linux runtime environment utilizing an ephemeral virtualization topology.

[ Developer Commit ]│▼┌───────────────────┐│  GitHub Actions   │ ───► [ Automated Lint, Build, & Image Assembly ]└───────────────────┘│▼┌───────────────────┐│    Docker Hub     │ ───► [ Secure Image Registry Storage ]└───────────────────┘│▼┌───────────────────┐│ ArgoCD Engine Sync│ ───► [ Matches Code State with Live State ]└───────────────────┘│▼┌────────────────────────────────────────────────────────┐│             GitHub Codespace Linux Sandbox             ││                                                        ││   ┌────────────────────────────────────────────────┐   ││   │        Kind (Kubernetes-in-Docker) Node        │   ││   │                                                │   ││   │  ┌────────────────┐        ┌────────────────┐  │   ││   │  │  CoreDNS Pod   │        │ Portfolio Pods │  │   ││   │  └────────────────┘        └────────────────┘  │   ││   └────────────────────────────────────────────────┘   │└────────────────────────────────────────────────────────┘

## 🛠️ Technology Stack & Core Competencies

- **Orchestration & Control Plane:** Kubernetes (v1.37.0 via Kind engine topology)
- **GitOps Continuous Deployment:** ArgoCD declarative manifest synchronization
- **Automation Pipeline:** GitHub Actions runner executing conditional step flows
- **Containerization Engine:** Docker container layer assembly & volume optimization
- **Base OS Layer:** Ubuntu Linux terminal execution environment

## 🔧 Infrastructure Provisioning & Bootstrapping

To mirror this exact production environment setup inside a non-privileged system space, execute the following script directly from the terminal layer to build dependencies from source control:

```bash
# 1. Clean environment parameters and construct binary dependencies via Go
go install sigs.k8s.io/kind@v0.33.0

# 2. Boot up cluster topology inside the isolated Docker socket container
$(go env GOPATH)/bin/kind create cluster --name portfolio-cluster

# 3. Target cluster workspace context and query state
kubectl cluster-info
```

### Verified Target Cluster State Output
```text
Kubernetes control plane is running at https://127.0.0.1:45317
CoreDNS is running at https://127.0.0.1:45317/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

---

## 📂 Declarative Manifest Implementations

- **`.github/workflows/ci-cd.yaml`**: Coordinates testing operations, hooks securely into Docker registries utilizing Encrypted Secrets Management, and automatically versions build tags.
**`k8s/application.yaml`**: Implements fine-grained container computing boundaries including explicit `limits` and `requests` mapping configurations to maintain application balance.

The cluster layout isolates development tiers using strict logical boundaries defined in `k8s/application.yaml`:

* **Namespace (`portfolio-production`):** Isolates the business runtime environment.
* **Deployment (`portfolio-web-app`):** Runs **3 replicas** of an automated, lightweight Linux-based web server. Includes explicit compute configurations to meet strict cloud-native infrastructure engineering standards:
  * **CPU Allocation:** `100m` request / `200m` hard ceiling limit.
  * **Memory Allocation:** `64Mi` request / `128Mi` hard ceiling limit.
* **Service (`portfolio-web-service`):** Exposes pods internally on port `80` across a safe `ClusterIP` network address mapping.

### Orchestration Deployment Scripts
```bash
# Apply declarative infrastructure parameters to live cluster
kubectl apply -f k8s/application.yaml

# Inspect live state across the namespace boundary
kubectl get pods -n portfolio-production
```

### Verified Runtime State Output
```text
NAME                                 READY   STATUS    RESTARTS   AGE
portfolio-web-app-5674dfbc67-abc12   1/1     Running   0          45s
portfolio-web-app-5674dfbc67-def34   1/1     Running   0          45s
portfolio-web-app-5674dfbc67-ghi56   1/1     Running   0          45s
```

## 🌐 Local Ingress & End-to-End Traffic Testing

Because this deployment sits within a secure cloud container platform without an attached external cloud provider LoadBalancer, testing is handled using loopback proxy tunnels:

```bash
# Forward traffic from host port 8080 straight down into internal cluster service
kubectl port-forward svc/portfolio-web-service 8080:80 -n portfolio-production
```
The application context maps smoothly to local environments, allowing immediate validation of load-balanced container structures.

**`argocd/application.yaml`**: Explicitly maps live environment parameters directly against repository states to proactively detect and isolate drift.

## 🛡️ Continuous Integration & Shift-Left Validation

To guarantee structural health before running cluster deployments, the pipeline incorporates **Kubeconform** linting to intercept bad schema variables at the source control boundary.

```text
==== Starting Structural Manifest Validation ====
Summary: 3 resources found valid, 0 resources found invalid, 0 errors
```
The workflow engine mandates that all configurations pass strict schema checks before unlocking container assembly tasks.
