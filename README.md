# gitops-kubernetes-infra
This is to show that I  can run automated deployments using a real GitOps workflow.
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
