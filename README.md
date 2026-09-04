# 🚀 Enterprise GitOps & Cloud-Native Infrastructure Pipeline

### Engineering Track Showcase | KCNA Certified

An automated, cloud-native infrastructure showcase demonstrating declarative GitOps workflows, automated application packaging, and localized multi-node container orchestration within resource-constrained server environments.

---

## 🏗️ Architectural Overview

This project bypasses traditional host-level administrative constraints by deploying an entire staging lifecycle inside a cloud-managed Linux runtime environment utilizing an ephemeral virtualization topology.

```text
       [ Developer Commit ]
               │
               ▼
     ┌───────────────────┐
     │   GitHub Actions  │ ───► [ Automated Lint, Build, & Image Assembly ]
     └───────────────────┘
               │
               ▼
     ┌───────────────────┐
     │     Docker Hub    │ ───► [ Secure Image Registry Storage ]
     └───────────────────┘
               │
               ▼
     ┌───────────────────┐
     │ ArgoCD Engine Sync│ ───► [ Matches Code State with Live State ]
     └───────────────────┘
               │
               ▼
┌────────────────────────────────────────────────────────┐
│             GitHub Codespace Linux Sandbox             │
│                                                        │
│   ┌────────────────────────────────────────────────┐   │
│   │         Kind (Kubernetes-in-Docker) Node       │   │
│   │                                                │   │
│   │  ┌────────────────┐        ┌────────────────┐  │   │
│   │  │  CoreDNS Pod   │        │ 3x Web App Pods│  │   │
│   │  └────────────────┘        └────────────────┘  │   │
│   └────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘

```

---

## 🛠️ Technology Stack & Core Competencies

* **Orchestration & Control Plane:** Kubernetes (v1.37.0 via Kind engine topology)
* **GitOps Continuous Deployment:** ArgoCD declarative manifest synchronization
* **Automation Pipeline:** GitHub Actions runner executing conditional step flows
* **Containerization Engine:** Docker container layer assembly & volume optimization
* **Base OS Layer:** Ubuntu Linux terminal execution environment

---

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

> Kubernetes control plane is running at [https://127.0.0.1:45317](https://127.0.0.1:45317)
> CoreDNS is running at [https://127.0.0.1:45317/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy](https://127.0.0.1:45317/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy)

---

## 📂 Declarative Manifest Implementations

* **`.github/workflows/ci-cd.yaml`**: Coordinates testing operations, hooks securely into Docker registries utilizing Encrypted Secrets Management, and automatically versions build tags.
* **`k8s/application.yaml`**: Implements fine-grained container computing boundaries including explicit `limits` and `requests` mapping configurations to maintain application balance.
* **`argocd-app.yaml`**: Explicitly maps live environment parameters directly against repository states to proactively detect and isolate drift.

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

---

## 🔄 The GitOps Workflow & ArgoCD Reconciliation

This cluster is actively managed by **ArgoCD** with Auto-Sync and Self-Healing enabled. Manual `kubectl apply` commands are actively rejected by the reconciliation loop to prevent configuration drift.

### SRE Debugging: The ArgoCD Quirk

* **The Scenario:** A new HTML ConfigMap was applied manually to the cluster, but web requests continually returned the old site data.
* **The Diagnosis:** The system experienced a strict GitOps reconciliation loop. ArgoCD detected the manual `kubectl apply` as unauthorized configuration drift. It instantly crushed the manual changes and reverted the ConfigMap back to the state stored in Git.
* **The Solution:** All infrastructure updates must flow exclusively through source control.

To successfully update the infrastructure or web content:

1. Modify the `k8s/application.yaml` manifest.
2. Commit and push the changes to GitHub as the single source of truth:

```bash
git add k8s/application.yaml
git commit -m "feat: update infrastructure state"
git push origin main

```

3. ArgoCD will automatically detect the commit, sync the new state to the cluster, and heal any drift.
4. **Kubernetes Quirk:** Because Kubernetes does not natively restart pods when a ConfigMap changes, a manual rollout restart is required after ArgoCD syncs to force the Nginx containers to mount the new data:

```bash
kubectl rollout restart deployment portfolio-web-app -n portfolio-production

```

---

## 🌐 Local Ingress & End-to-End Traffic Testing

Because this deployment sits within a secure cloud container platform without an attached external cloud provider LoadBalancer, testing is handled using loopback proxy tunnels.

If you are developing inside GitHub Codespaces, aggressive proxy caching can sometimes serve stale HTML even after a successful GitOps deployment. To completely bypass the cache and view the live cluster internally, establish a fresh port-forward tunnel on a new port (e.g., `9999`):

```bash
# Forward traffic from host port 9999 straight down into internal cluster service
kubectl port-forward svc/portfolio-web-service 9999:80 -n portfolio-production

```

The application context maps smoothly to local environments. Navigate to `http://localhost:9999` to allow immediate validation of the load-balanced container structures.

---

## 🛡️ Continuous Integration & Shift-Left Validation

To guarantee structural health before running cluster deployments, the pipeline incorporates **Kubeconform** linting to intercept bad schema variables at the source control boundary.

> ==== Starting Structural Manifest Validation ====
> Summary: 3 resources found valid, 0 resources found invalid, 0 errors

The workflow engine mandates that all configurations pass strict schema checks before unlocking container assembly tasks.

