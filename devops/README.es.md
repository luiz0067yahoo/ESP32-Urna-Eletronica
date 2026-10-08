# 🛠️ DevOps • Guía Unificada de Infraestructura

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

</div>

Este directorio contiene soluciones completas de infraestructura y orquestación para la **Urna Electrónica Pokémon**, organizadas en carpetas modulares para cualquier entorno de despliegue:

---

## 📂 Entornos y Enfoques Disponibles

### 1. [🐳 Docker (`devops/docker/`)](docker/README.md)
- **Tecnologías:** Docker, Docker Compose, Apache + PHP 8.2, MariaDB 10.11, phpMyAdmin.
- **Destacados:** Inicio en 1 solo comando, healthchecks automáticos, inicialización inteligente con migraciones y datos vía `docker-entrypoint.sh`.
- **Cómo ejecutar:**
  - Windows: `devops\docker\start.bat`
  - Linux/macOS: `./devops/docker/start.sh`

### 2. [🦭 Podman (`devops/podman/`)](podman/README.md)
- **Tecnologías:** Podman (Rootless, Daemonless), `Containerfile`, Pods Nativos de Podman, `podman-compose`.
- **Destacados:** Soporte nativo a Pods compartiendo `localhost`, compatibilidad con SELinux (`:Z`), exportación a Kubernetes (`podman generate kube`).
- **Cómo ejecutar:**
  - Pod Nativo (Linux/macOS): `./devops/podman/start-pod.sh`
  - Pod Nativo (Windows): `devops\podman\start-pod.bat`
  - Podman Compose: `./devops/podman/start-compose.sh`

### 3. [☸️ Kubernetes (`devops/kubernetes/`)](kubernetes/README.md)
- **Tecnologías:** Kubernetes, Kustomize, PVC, ConfigMap, Secret, Deployments, NodePort Service, Ingress.
- **Destacados:** Namespace dedicado (`urna-eletronica`), 2 réplicas con alta disponibilidad, `initContainers` para sincronización de base de datos, sondas de preparación (`readiness`) y vida (`liveness`).
- **Cómo ejecutar:**
  - Windows: `devops\kubernetes\deploy.bat`
  - Linux/macOS: `./devops/kubernetes/deploy.sh`
  - Manual: `kubectl apply -k devops/kubernetes/`

### 4. [⚙️ Piku / Nativo (`devops/config/`)](config/README.md)
- **Tecnologías:** Piku (PaaS minimalista), Nginx VHost nativo, scripts shell/batch para ejecución directa en el host sin contenedores.
- **Cómo ejecutar:**
  - Windows: `devops\config\start.bat`
  - Linux/macOS: `./devops/config/start.sh`

---

## 🌐 Puertos Predeterminados de Acceso

| Servicio | Puerto | URL |
| :--- | :--- | :--- |
| **Cabina de Votación (Frontend)** | `8080` (o `30080` en K8s) | `http://localhost:8080/frontend/index.html` |
| **Escrutinio en Directo (Frontend)** | `8080` (o `30080` en K8s) | `http://localhost:8080/frontend/apuracao.html` |
| **API REST Backend** | `8080` (o `30080` en K8s) | `http://localhost:8080/backend/apuracao` |
| **phpMyAdmin (DB Web UI)** | `8081` | `http://localhost:8081` |

---

## 🔄 Despliegue Automático vía Git en Todos los Entornos

Todos los entornos cuentan con mecanismos de despliegue continuo mediante Git:

| Entorno | 1. Script Automático (`deploy-git`) | 2. Git Hook en Servidor (`git push`) | 3. GitHub Actions CI/CD | 4. GitOps |
| :--- | :--- | :--- | :--- | :--- |
| **Docker** | `devops/docker/deploy-git.sh` | `devops/docker/git-hook-post-receive` | `.github/workflows/docker-ci-cd.yml` | - |
| **Podman** | `devops/podman/deploy-git.sh` | `devops/podman/git-hook-post-receive` | `.github/workflows/podman-ci-cd.yml` | - |
| **Kubernetes** | `devops/kubernetes/deploy-git.sh` | `devops/kubernetes/git-hook-post-receive` | `.github/workflows/kubernetes-ci-cd.yml` | `devops/kubernetes/gitops-argocd.yaml` |

- **GitHub Actions:** Al ejecutar `git push origin main`, las imágenes se compilan automáticamente, se etiquetan con el hash del commit y se publican en GitHub Container Registry (GHCR).
- **Git Push Directo (Bare Repo):** En servidores VPS/Cloud, tras configurar `git remote add production ...` y ejecutar `git push production main`, el hook `post-receive` realiza el checkout y recarga los contenedores/pods sin interrupción de servicio.
- **GitOps (ArgoCD en Kubernetes):** El clúster monitoriza el repositorio Git en tiempo real y sincroniza nuevos commits de forma declarativa.
