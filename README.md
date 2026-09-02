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
**`k8s/deployment.yaml`**: Implements fine-grained container computing boundaries including explicit `limits` and `requests` mapping configurations to maintain application balance.
**`argocd/application.yaml`**: Explicitly maps live environment parameters directly against repository states to proactively detect and isolate drift.

# File structure
gitops-kubernetes-infra/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml         # Automatically builds and tests your app
├── k8s/
│   ├── deployment.yaml        # Defines how your app runs in K8s
│   └── service.yaml           # Exposes your app to the internet
└── argocd/
    └── application.yaml       # Teaches ArgoCD to watch this repo
