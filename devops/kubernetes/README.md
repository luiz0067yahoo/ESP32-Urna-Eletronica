# ☸️ DevOps • Kubernetes

Manifestos prontos para produção e testes em clusters Kubernetes (**Minikube**, **Kind**, **k3s**, **Docker Desktop Kubernetes**, **EKS**, **GKE**, **AKS**).

---

## 📁 Estrutura desta pasta

| Arquivo | Descrição |
| :--- | :--- |
| `00-namespace.yaml` | Namespace isolado `urna-eletronica`. |
| `01-configmap.yaml` | Variáveis de configuração (`DB_HOST`, `DB_PORT`, `DB_NAME`, `APP_ENV`). |
| `02-secret.yaml` | Credenciais sensíveis (`DB_USER`, `DB_PASS`, `MYSQL_ROOT_PASSWORD`). |
| `03-mysql-pvc.yaml` | `PersistentVolumeClaim` para persistência dos dados do MariaDB/MySQL. |
| `04-mysql-deployment.yaml` | Deployment e Service interno (`urna-db`) com probes de saúde. |
| `05-app-deployment.yaml` | Deployment com 2 réplicas, `initContainer` de espera pelo banco, liveness e readiness probes. |
| `06-app-service.yaml` | Service do tipo `NodePort` (porta 30080) para acesso simplificado em qualquer cluster local. |
| `07-ingress.yaml` | Definição de Ingress para roteamento HTTP via NGINX Ingress Controller. |
| `kustomization.yaml` | Configuração Kustomize para aplicar todos os manifestos com um único comando (`kubectl apply -k .`). |
| `gitops-argocd.yaml` | **GitOps:** Manifesto do ArgoCD para sincronização contínua e automática a cada `git push` no repositório. |
| `deploy-git.sh` / `.bat` | **Deploy Automático via Git:** Atualiza do Git, constrói com tag de commit SHA e faz rollout no Kubernetes. |
| `git-hook-post-receive` | Hook para servidores: ao executar `git push production main`, executa o deploy no Kubernetes. |
| `deploy.sh` / `deploy.bat` | Script automatizado para compilar a imagem e realizar o deploy completo. |
| `destroy.sh` / `destroy.bat` | Script para desinstalar e limpar todos os recursos do cluster. |

---

## 🚀 Como Fazer o Deploy

### Opção 1: Via Script Automatizado

- **No Windows:**
  ```cmd
  devops\kubernetes\deploy.bat
  ```

- **No Linux / macOS:**
  ```bash
  chmod +x devops/kubernetes/*.sh
  ./devops/kubernetes/deploy.sh
  ```

O script irá:
1. Construir a imagem local `urna-app:latest` (se estiver no Minikube/Kind, ele carrega a imagem diretamente no cluster).
2. Aplicar todos os recursos no namespace `urna-eletronica`.
3. Aguardar o banco e a aplicação atingirem o status `Ready`.

---

### Opção 2: Manualmente com `kubectl`

1. Construa a imagem da aplicação:
   ```bash
   docker build -t urna-app:latest -f devops/docker/Dockerfile .
   ```

2. Se estiver usando Minikube:
   ```bash
   minikube image load urna-app:latest
   ```

3. Aplique os manifestos via Kustomize:
   ```bash
   kubectl apply -k devops/kubernetes/
   ```

4. Verifique o status dos Pods:
   ```bash
   kubectl get pods -n urna-eletronica
   ```

---

## 🌐 Como Acessar a Aplicação

### 1. Via NodePort (Porta 30080):
- [http://localhost:30080/frontend/index.html](http://localhost:30080/frontend/index.html)

*(No Minikube, se necessário, use: `minikube service urna-app-service -n urna-eletronica`)*

### 2. Via Port-Forwarding:
```bash
kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
```
Em seguida acesse no navegador:
- [http://localhost:8080/frontend/index.html](http://localhost:8080/frontend/index.html)
- [http://localhost:8080/frontend/apuracao.html](http://localhost:8080/frontend/apuracao.html)

---

## 🧹 Como Desinstalar

Para remover todos os recursos criados:
```bash
./devops/kubernetes/destroy.sh
# ou no Windows:
devops\kubernetes\destroy.bat
```
Ou com `kubectl`:
```bash
kubectl delete -k devops/kubernetes/
```

---

## 🔄 Deploy Automático via Git & GitOps

### 1. GitOps com ArgoCD (Nativo Kubernetes)
O arquivo [gitops-argocd.yaml](file:///c:/Users/10345/Documents/GitHub/ESP32%20Urna%20Eletronica/devops/kubernetes/gitops-argocd.yaml) configura o ArgoCD para monitorar este repositório Git. Qualquer alteração ou `git push` na branch `main` sincroniza e aplica os manifestos automaticamente no cluster, com auto-cura (`selfHeal: true`) e remoção de recursos órfãos (`prune: true`).

Para ativar:
```bash
kubectl apply -f devops/kubernetes/gitops-argocd.yaml
```

### 2. Script de Atualização Contínua (`deploy-git.sh` / `deploy-git.bat`)
Para executar em pipelines ou no host do cluster:
```bash
./devops/kubernetes/deploy-git.sh main
```
Ele atualiza o código do Git, constrói a imagem com a hash do commit, aplica os manifestos Kustomize e executa um `rollout restart` assistido com verificação de prontidão.

### 3. Via GitHub Actions CI/CD
O workflow [.github/workflows/kubernetes-ci-cd.yml](file:///c:/Users/10345/Documents/GitHub/ESP32%20Urna%20Eletronica/.github/workflows/kubernetes-ci-cd.yml) constrói a imagem a cada push na branch `main`, publica no GitHub Packages (GHCR) e atualiza o cluster via `kubectl` caso o secret `KUBECONFIG` esteja configurado no repositório.

