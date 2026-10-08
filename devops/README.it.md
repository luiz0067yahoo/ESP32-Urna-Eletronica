# 🛠️ DevOps • Guida Unificata all'Infrastruttura

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

</div>

Questa directory raccoglie soluzioni complete di infrastruttura e orchestrazione container per l'**Urna Elettronica Pokémon**, strutturate in cartelle modulari per qualsiasi scenario di distribuzione:

---

## 📂 Ambienti e Soluzioni Disponibili

### 1. [🐳 Docker (`devops/docker/`)](docker/README.md)
- **Tecnologie:** Docker, Docker Compose, Apache + PHP 8.2, MariaDB 10.11, phpMyAdmin.
- **Punti di Forza:** Avvio con 1 comando, healthcheck automatici, bootstrap intelligente con migrazioni e seed tramite `docker-entrypoint.sh`.
- **Come eseguire:**
  - Windows: `devops\docker\start.bat`
  - Linux/macOS: `./devops/docker/start.sh`

### 2. [🦭 Podman (`devops/podman/`)](podman/README.md)
- **Tecnologie:** Podman (Rootless, Daemonless), `Containerfile`, Pod Nativi Podman, `podman-compose`.
- **Punti di Forza:** Supporto nativo a Pod multi-container su `localhost`, compatibilità con SELinux (`:Z`), esportazione verso Kubernetes (`podman generate kube`).
- **Come eseguire:**
  - Pod Nativo (Linux/macOS): `./devops/podman/start-pod.sh`
  - Pod Nativo (Windows): `devops\podman\start-pod.bat`
  - Podman Compose: `./devops/podman/start-compose.sh`

### 3. [☸️ Kubernetes (`devops/kubernetes/`)](kubernetes/README.md)
- **Tecnologie:** Kubernetes, Kustomize, PVC, ConfigMap, Secret, Deployments, NodePort Service, Ingress.
- **Punti di Forza:** Namespace dedicato (`urna-eletronica`), 2 repliche in alta disponibilità, `initContainers` per la sincronizzazione del database, probe di prontezza (`readiness`) e vitalità (`liveness`).
- **Come eseguire:**
  - Windows: `devops\kubernetes\deploy.bat`
  - Linux/macOS: `./devops/kubernetes/deploy.sh`
  - Manuale: `kubectl apply -k devops/kubernetes/`

### 4. [⚙️ Piku / Host Nativo (`devops/config/`)](config/README.md)
- **Tecnologie:** Piku (PaaS minimale), Nginx VHost nativo, script shell e batch per esecuzione diretta sull'host senza container.
- **Come eseguire:**
  - Windows: `devops\config\start.bat`
  - Linux/macOS: `./devops/config/start.sh`

---

## 🌐 Porte Predefinite di Accesso

| Servizio | Porta | URL |
| :--- | :--- | :--- |
| **Cabina Elettorale (Frontend)** | `8080` (o `30080` in K8s) | `http://localhost:8080/frontend/index.html` |
| **Scrutinio dal Vivo (Frontend)** | `8080` (o `30080` in K8s) | `http://localhost:8080/frontend/apuracao.html` |
| **API REST Backend** | `8080` (o `30080` in K8s) | `http://localhost:8080/backend/apuracao` |
| **phpMyAdmin (DB Web UI)** | `8081` | `http://localhost:8081` |

---

## 🔄 Deploy Automatico via Git in Tutti gli Ambienti

Tutti gli ambienti includono pipeline di distribuzione continua tramite Git:

| Ambiente | 1. Script Automatico (`deploy-git`) | 2. Git Hook sul Server (`git push`) | 3. GitHub Actions CI/CD | 4. GitOps |
| :--- | :--- | :--- | :--- | :--- |
| **Docker** | `devops/docker/deploy-git.sh` | `devops/docker/git-hook-post-receive` | `.github/workflows/docker-ci-cd.yml` | - |
| **Podman** | `devops/podman/deploy-git.sh` | `devops/podman/git-hook-post-receive` | `.github/workflows/podman-ci-cd.yml` | - |
| **Kubernetes** | `devops/kubernetes/deploy-git.sh` | `devops/kubernetes/git-hook-post-receive` | `.github/workflows/kubernetes-ci-cd.yml` | `devops/kubernetes/gitops-argocd.yaml` |

- **GitHub Actions:** Con ogni `git push origin main`, le immagini container vengono compilate automaticamente, etichettate con l'hash del commit e pubblicate su GitHub Container Registry (GHCR).
- **Git Push Diretto (Bare Repo):** Su server VPS/Cloud, aggiungendo `git remote add production ...` ed eseguendo `git push production main`, l'hook `post-receive` effettua il checkout e riavvia i container/pod senza interruzioni di servizio.
- **GitOps (ArgoCD su Kubernetes):** Il cluster monitora il repository Git in tempo reale sincronizzando automaticamente i nuovi commit in modalità dichiarativa.
