# 🛠️ DevOps • Guia Unificado de Infraestrutura

Este diretório contém soluções completas de infraestrutura e orquestração para a **Urna Eletrônica Pokémon**, organizadas em pastas modulares para atender a qualquer cenário de implantação:

---

## 📂 Pastas e Abordagens Disponíveis

### 1. [🐳 Docker (`devops/docker/`)](docker/README.md)
- **Tecnologias:** Docker, Docker Compose, Apache + PHP 8.2, MariaDB 10.11, phpMyAdmin.
- **Destaques:** Inicia tudo em 1 comando, healthchecks automáticos, inicialização inteligente com migrações e seed via `docker-entrypoint.sh`.
- **Como rodar:**
  - Windows: `devops\docker\start.bat`
  - Linux/macOS: `./devops/docker/start.sh`

### 2. [🦭 Podman (`devops/podman/`)](podman/README.md)
- **Tecnologias:** Podman (Rootless, Daemonless), `Containerfile`, Pods Nativos Podman, `podman-compose`.
- **Destaques:** Suporte nativo a Pods compartilhando `localhost`, compatibilidade com SELinux (`:Z`), exportador para Kubernetes (`podman generate kube`).
- **Como rodar:**
  - Pod Nativo (Linux/macOS): `./devops/podman/start-pod.sh`
  - Pod Nativo (Windows): `devops\podman\start-pod.bat`
  - Podman Compose: `./devops/podman/start-compose.sh`

### 3. [☸️ Kubernetes (`devops/kubernetes/`)](kubernetes/README.md)
- **Tecnologias:** Kubernetes, Kustomize, PVC, ConfigMap, Secret, Deployments, NodePort Service, Ingress.
- **Destaques:** Namespace isolado (`urna-eletronica`), 2 réplicas com alta disponibilidade, `initContainers` para sincronismo de banco, probes de prontidão (`readiness`) e vivacidade (`liveness`).
- **Como rodar:**
  - Windows: `devops\kubernetes\deploy.bat`
  - Linux/macOS: `./devops/kubernetes/deploy.sh`
  - Manual: `kubectl apply -k devops/kubernetes/`

### 4. [⚙️ Piku / Nativo (`devops/config/`)](config/README.md)
- **Tecnologias:** Piku (PaaS minimalista), Nginx VHost nativo, scripts shell/batch para execução direta no host sem containers.
- **Como rodar:**
  - Windows: `devops\config\start.bat`
  - Linux/macOS: `./devops/config/start.sh`

---

## 🌐 Portas Padrão de Acesso

| Serviço | Porta | URL |
| :--- | :--- | :--- |
| **Urna Eletrônica (Frontend)** | `8080` (ou `30080` no K8s) | `http://localhost:8080/frontend/index.html` |
| **Apuração ao Vivo (Frontend)** | `8080` (ou `30080` no K8s) | `http://localhost:8080/frontend/apuracao.html` |
| **API REST Backend** | `8080` (ou `30080` no K8s) | `http://localhost:8080/backend/apuracao` |
| **phpMyAdmin (DB Web UI)** | `8081` | `http://localhost:8081` |

---

## 🔄 Deploy Automático via Git em Todos os Ambientes

Todos os três ambientes contam com 3 mecanismos de deploy contínuo via Git:

| Ambiente | 1. Script Automático (`deploy-git`) | 2. Git Hook no Servidor (`git push`) | 3. GitHub Actions CI/CD | 4. GitOps |
| :--- | :--- | :--- | :--- | :--- |
| **Docker** | `devops/docker/deploy-git.sh` | `devops/docker/git-hook-post-receive` | `.github/workflows/docker-ci-cd.yml` | - |
| **Podman** | `devops/podman/deploy-git.sh` | `devops/podman/git-hook-post-receive` | `.github/workflows/podman-ci-cd.yml` | - |
| **Kubernetes** | `devops/kubernetes/deploy-git.sh` | `devops/kubernetes/git-hook-post-receive` | `.github/workflows/kubernetes-ci-cd.yml` | `devops/kubernetes/gitops-argocd.yaml` |

- **GitHub Actions:** Ao realizar `git push origin main`, as imagens são automaticamente compiladas, versionadas com a hash do commit e publicadas no GitHub Container Registry (GHCR).
- **Git Push Direto (Bare Repo):** Em servidores VPS/Cloud, ao adicionar `git remote add production ...` e rodar `git push production main`, o hook `post-receive` executa o checkout e recarrega os containers/pods sem parada de serviço.
- **GitOps (ArgoCD no Kubernetes):** O cluster monitora o repositório Git em tempo real e sincroniza qualquer novo commit automaticamente.

