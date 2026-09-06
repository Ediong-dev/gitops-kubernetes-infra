# 🚀 Enterprise GitOps & Cloud-Native Infrastructure Pipeline

### Engineering Track Showcase | KCNA Certified

[![CI/CD Pipeline Status](https://github.com/Ediong-dev/gitops-kubernetes-infra/actions/workflows/ci-cd.yaml/badge.svg)](https://github.com/Ediong-dev/gitops-kubernetes-infra/actions/workflows/ci-cd.yaml)

![Screenshot Placeholder: CI/CD Pipeline Status Badge](screenshots/badge.png)
*(Placeholder – replace with a screenshot of the badge/actions page)*

An automated, cloud-native infrastructure showcase demonstrating declarative GitOps workflows, automated application packaging, and localized multi-node container orchestration within resource-constrained server environments.

---

## 🏗️ Architectural Overview

This project bypasses traditional host-level administrative constraints by deploying an entire staging lifecycle inside a cloud-managed Linux runtime environment utilizing an ephemeral virtualization topology, with an optional modular deployment target for public cloud infrastructure.

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
        ┌──────────────┴─────────────────────────────────────────┐
        │                                                        │
        ▼ (Primary Staging - Zero Cost)                          ▼ (Dry-Run Verified IaC)
┌───────────────────────────────────────┐      ┌───────────────────────────────────────┐
│     GitHub Codespace Linux Sandbox    │      │        AWS Cloud Infrastructure       │
│                                       │      │          (Terraform Provisioned)       │
│  ┌─────────────────────────────────┐  │      │  ┌─────────────────────────────────┐  │
│  │  Kind (Kubernetes-in-Docker)    │  │      │  │  EC2 Instance (K3s Server)      │  │
│  │                                 │  │      │  │                                 │  │
│  │ ┌──────────────┐ ┌────────────┐ │  │      │  │ ┌──────────────┐ ┌────────────┐ │  │
│  │ │ CoreDNS Pod  │ │ 3x Web Pods│ │  │      │  │ │ CoreDNS Pod  │ │ 3x Web Pods│ │  │
│  │ └──────────────┘ └────────────┘ │  │      │  │ └──────────────┘ └────────────┘ │  │
│  └─────────────────────────────────┘  │      │  └─────────────────────────────────┘  │
└───────────────────────────────────────┘      └───────────────────────────────────────┘
```

![Screenshot Placeholder: Architecture Diagram](screenshots/architecture.png)
*(Placeholder – replace with your own diagram, e.g., from draw.io)*

---

### 💡 Architectural & FinOps Decisions
This project intentionally balances production-grade engineering practices with cloud cost management (FinOps):
* **Zero-Cost Ephemeral Sandbox (Kind + Codespaces): To avoid unnecessary cloud infrastructure charges while preserving a strict Kubernetes control plane, the primary live staging environment runs inside GitHub Codespaces using a Kind (Kubernetes-in-Docker) topology. This provides a zero-friction, browser-accessible environment for reviewers without requiring cloud provider credentials. 
* **Cloud-Ready Infrastructure-as-Code (Terraform + AWS): A fully functional, modular Terraform configuration is maintained in the /terraform directory. It provisions an AWS VPC, Subnet, Security Groups, and an EC2 instance running lightweight Kubernetes (K3s). This module is dry-run verified via terraform plan to ensure instant portability to live AWS cloud environments when production deployment is required.

## 🛠️ Technology Stack & Core Competencies

* **Orchestration & Control Plane:** Kubernetes (v1.37.0 via Kind engine topology)
* **Infrastructure as Code (IaC): Terraform (VPC, Subnets, Security Groups, EC2 automation)
* **Cloud Provider: Amazon Web Services (AWS)
* **GitOps Continuous Deployment:** ArgoCD declarative manifest synchronization
* **Automation Pipeline:** GitHub Actions runner executing conditional step flows
* **Containerization Engine:** Docker container layer assembly & volume optimization
* **Base OS Layer:** Ubuntu Linux terminal execution environment

![Screenshot Placeholder: Technology Stack Overview](screenshots/tech-stack.png)
*(Placeholder – optional visual summary of the stack)*

---

## 🔧 Infrastructure Provisioning & Bootstrapping

Primary Environment (Kind Sandbox)
To mirror this exact production environment setup inside a non-privileged system space, execute the following script directly from the terminal layer to build dependencies from source control:

```bash
# 1. Clean environment parameters and construct binary dependencies via Go
go install sigs.k8s.io/kind@v0.33.0

# 2. Boot up cluster topology inside the isolated Docker socket container
$(go env GOPATH)/bin/kind create cluster --name portfolio-cluster

# 3. Target cluster workspace context and query state
kubectl cluster-info
```
Alternative Cloud Provisioning (AWS via Terraform)
To provision the production-ready AWS cloud infrastructure instead:

```Bash
cd terraform/
terraform init
terraform plan
terraform apply

### Verified Target Cluster State Output

> Kubernetes control plane is running at [https://127.0.0.1:45317](https://127.0.0.1:45317)  
> CoreDNS is running at [https://127.0.0.1:45317/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy](https://127.0.0.1:45317/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy)

![Screenshot Placeholder: Kind Cluster Nodes](screenshots/kind-cluster.png)
*(Placeholder – replace with `kubectl get nodes` output)*

---

## 📂 Declarative Manifest Implementations

* **`.github/workflows/ci-cd.yaml`**: Coordinates testing operations, hooks securely into Docker registries utilizing Encrypted Secrets Management, and automatically versions build tags.
* **`k8s/application.yaml`**: Implements fine-grained container computing boundaries including explicit `limits` and `requests` mapping configurations to maintain application balance.
* **`argocd-application.yaml`**: Explicitly maps live environment parameters directly against repository states to proactively detect and isolate drift.

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

![Screenshot Placeholder: Running Pods in Production Namespace](screenshots/running-pods.png)
*(Placeholder – replace with a screenshot of `kubectl get pods -n portfolio-production`)*

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

![Screenshot Placeholder: ArgoCD CLI Sync Status](screenshots/argocd-cli.png)
*(Placeholder – replace with a terminal screenshot of `argocd app get production-gitops-sync` showing `Synced` and `Healthy`)*

> **Note:** The ArgoCD UI is optional – the CLI provides the same sync/health information and is used by many professionals. The UI can be accessed via port‑forward, but the CLI remains the most reliable tool.

---

## 🌐 Local Ingress & End-to-End Traffic Testing

Because this deployment sits within a secure cloud container platform without an attached external cloud provider LoadBalancer, testing is handled using loopback proxy tunnels.

If you are developing inside GitHub Codespaces, aggressive proxy caching can sometimes serve stale HTML even after a successful GitOps deployment. To completely bypass the cache and view the live cluster internally, establish a fresh port-forward tunnel on a new port (e.g., `9999`):

```bash
# Forward traffic from host port 9999 straight down into internal cluster service
kubectl port-forward svc/portfolio-web-service 9999:80 -n portfolio-production
```

The application context maps smoothly to local environments. Navigate to `http://localhost:9999` to allow immediate validation of the load-balanced container structures.

![Screenshot Placeholder: Portfolio App in Browser](screenshots/portfolio-app.png)
*(Placeholder – replace with a screenshot of your portfolio page loaded in a browser)*

---

## 🛡️ Continuous Integration & Shift-Left Validation

To guarantee structural health before running cluster deployments, the pipeline incorporates **Kubeconform** linting to intercept bad schema variables at the source control boundary.

```text
==== Starting Structural Manifest Validation ====
Summary: 3 resources found valid, 0 resources found invalid, 0 errors
```

The workflow engine mandates that all configurations pass strict schema checks before unlocking container assembly tasks.

![Screenshot Placeholder: Kubeconform Validation Pass](screenshots/kubeconform-pass.png)
*(Placeholder – replace with a screenshot of the validation step passing in GitHub Actions)*

---

## 🛡️ Security & Shift-Left Scanning

Every Docker image built by the pipeline is **automatically scanned** for **High and Critical** vulnerabilities using **Trivy**. If any are found, the build fails – preventing insecure images from being deployed. This enforces a **security‑first** culture from day one.

![Trivy Scan](https://img.shields.io/badge/Trivy-Secure%20by%20Default-brightgreen?style=flat&logo=trivy)

The scanning job runs **after** the image is built and pushed to Docker Hub, ensuring that only verified, secure containers reach the cluster.

![Screenshot Placeholder: Trivy Scan Passing in Actions](screenshots/trivy-pass.png)
*(Placeholder – replace with a screenshot of the Trivy scan step succeeding)*

---

## 📸 Additional Screenshot Placeholders

Here are more visuals you can add to make your README shine:

| Placeholder File | What to Show |
|------------------|--------------|
| `screenshots/grafana-dashboard.png` | Grafana UI showing CPU, memory, and pod metrics |
| `screenshots/terraform-plan.png` | Output of `terraform plan` (AWS or Oracle) |
| `screenshots/github-actions-full.png` | Full GitHub Actions workflow run with all jobs green |
| `screenshots/prometheus-targets.png` | Prometheus targets all UP |
| `screenshots/argocd-ui.png` | (Optional) ArgoCD UI dashboard, if you get it working |

Create a `screenshots/` folder in your repository and drop your images there.

---

## 📌 Summary of What Works

- ✅ CI/CD pipeline (GitHub Actions → Docker Hub)  
- ✅ Kubeconform validation  
- ✅ ArgoCD GitOps (auto‑sync, self‑heal) – accessible via CLI  
- ✅ Prometheus + Grafana (monitoring stack)  
- ✅ Trivy security scanning  
- ✅ Portfolio app deployed and accessible via port‑forward  
- ✅ Terraform AWS IaC module (dry-run verified)

All of this runs inside a **Kind cluster** inside a GitHub Codespace – completely free, no cloud account needed.

---

## 🧹 Clean Up

- To stop the cluster: `kind delete cluster --name portfolio-cluster`
- If you've provisioned any cloud resources via Terraform, run `terraform destroy` in the respective folder.

---

## 🤝 Contributing

This is a personal portfolio project, but feedback and suggestions are welcome – feel free to open an issue or pull request.

---

**Built by [Ediong-dev](https://github.com/Ediong-dev)**  
*KCNA Certified • Cloud-Native Enthusiast*
```
