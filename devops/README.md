# 🛠️ DevOps • Unified Infrastructure Guide

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

</div>

This directory contains complete infrastructure and container orchestration stacks for the **Pokémon Electronic Voting Machine**, organized into modular folders for any deployment target:

---

## 📂 Available Environments and Stacks

### 1. [🐳 Docker (`devops/docker/`)](docker/README.md)
- **Technologies:** Docker, Docker Compose, Apache + PHP 8.2, MariaDB 10.11, phpMyAdmin.
- **Highlights:** 1-command startup, automatic healthchecks, zero-configuration bootstrap with migrations and seeds via `docker-entrypoint.sh`.
- **How to Run:**
  - Windows: `devops\docker\start.bat`
  - Linux/macOS: `./devops/docker/start.sh`

### 2. [🦭 Podman (`devops/podman/`)](podman/README.md)
- **Technologies:** Podman (Rootless, Daemonless), `Containerfile`, Podman Native Pods, `podman-compose`.
- **Highlights:** Native multi-container Pods sharing `localhost`, SELinux compatibility (`:Z`), Kubernetes export (`podman generate kube`).
- **How to Run:**
  - Native Pod (Linux/macOS): `./devops/podman/start-pod.sh`
  - Native Pod (Windows): `devops\podman\start-pod.bat`
  - Podman Compose: `./devops/podman/start-compose.sh`

### 3. [☸️ Kubernetes (`devops/kubernetes/`)](kubernetes/README.md)
- **Technologies:** Kubernetes, Kustomize, PVC, ConfigMap, Secret, Deployments, NodePort Service, Ingress.
- **Highlights:** Dedicated namespace (`urna-eletronica`), 2 high-availability replicas, `initContainers` for DB migrations, readiness and liveness probes.
- **How to Run:**
  - Windows: `devops\kubernetes\deploy.bat`
  - Linux/macOS: `./devops/kubernetes/deploy.sh`
  - Manual: `kubectl apply -k devops/kubernetes/`

### 4. [⚙️ Piku / Native Host (`devops/config/`)](config/README.md)
- **Technologies:** Piku (minimalist PaaS), native Nginx VHost, shell and batch scripts for running directly on host without containers.
- **How to Run:**
  - Windows: `devops\config\start.bat`
  - Linux/macOS: `./devops/config/start.sh`

---

## 🌐 Default Access Ports

| Service | Port | URL |
| :--- | :--- | :--- |
| **Voting Booth (Frontend)** | `8080` (or `30080` in K8s) | `http://localhost:8080/frontend/index.html` |
| **Live Results Tally (Frontend)** | `8080` (or `30080` in K8s) | `http://localhost:8080/frontend/apuracao.html` |
| **RESTful API Backend** | `8080` (or `30080` in K8s) | `http://localhost:8080/backend/apuracao` |
| **phpMyAdmin (DB Web UI)** | `8081` | `http://localhost:8081` |

---

## 🔄 Automated Git Deployment Across All Environments

All environments feature automated continuous deployment mechanisms via Git:

| Environment | 1. Automated Script (`deploy-git`) | 2. Git Hook on Server (`git push`) | 3. GitHub Actions CI/CD | 4. GitOps |
| :--- | :--- | :--- | :--- | :--- |
| **Docker** | `devops/docker/deploy-git.sh` | `devops/docker/git-hook-post-receive` | `.github/workflows/docker-ci-cd.yml` | - |
| **Podman** | `devops/podman/deploy-git.sh` | `devops/podman/git-hook-post-receive` | `.github/workflows/podman-ci-cd.yml` | - |
| **Kubernetes** | `devops/kubernetes/deploy-git.sh` | `devops/kubernetes/git-hook-post-receive` | `.github/workflows/kubernetes-ci-cd.yml` | `devops/kubernetes/gitops-argocd.yaml` |

- **GitHub Actions:** Pushing to `origin main` triggers automated builds, tag versioning with commit hashes, and container publication to the GitHub Container Registry (GHCR).
- **Direct Git Push (Bare Repo):** On VPS/Cloud servers, adding `git remote add production ...` and executing `git push production main` invokes the `post-receive` hook to pull changes and restart containers/pods without downtime.
- **GitOps (ArgoCD on Kubernetes):** The cluster tracks the Git repository continuously and syncs new commits declaratively.
