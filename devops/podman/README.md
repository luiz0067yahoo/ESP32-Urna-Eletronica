# 🦭 DevOps • Podman & Podman Compose

Instruções e scripts para executar a **Urna Eletrônica Pokémon** com **Podman** (Rootless, sem daemon e seguro por padrão).

---

## 📁 Estrutura desta pasta

| Arquivo | Descrição |
| :--- | :--- |
| `Containerfile` | Definição da imagem OCI padrão Podman (Apache + PHP 8.2 + PDO MySQL). |
| `podman-entrypoint.sh` | Entrypoint com checagem de banco e migração/seed automatizada. |
| `podman-compose.yml` | Orquestração multi-container compatível com `podman-compose` e flags `:Z` de SELinux. |
| `start-pod.sh` / `start-pod.bat` | **Modo Nativo Podman:** Cria um Pod com rede compartilhada (`127.0.0.1`) entre MariaDB e Aplicação. |
| `stop-pod.sh` / `stop-pod.bat` | Para e remove o Pod nativo Podman. |
| `start-compose.sh` / `start-compose.bat` | Inicia o ambiente usando `podman-compose`. |
| `stop-compose.sh` / `stop-compose.bat` | Para o ambiente do `podman-compose`. |
| `deploy-git.sh` / `.bat` | **Deploy Automático via Git:** Atualiza do Git, reconstrói imagens e recarrega os pods/containers com migrações. |
| `git-hook-post-receive` | Hook para servidores: ao executar `git push production main`, atualiza a aplicação e o pod automaticamente. |
| `generate-kube.sh` | Exporta o Pod nativo do Podman diretamente para um manifesto YAML do Kubernetes (`podman generate kube`). |

---

## 🚀 Como Executar

O Podman oferece duas formas excelentes de execução:

### Modo 1: Pod Nativo Podman (Recomendado)
Este modo cria um Pod único na máquina onde os containers compartilham a mesma pilha de rede (`localhost`), idêntico à arquitetura de pods do Kubernetes!

- **Linux / macOS:**
  ```bash
  chmod +x devops/podman/*.sh
  ./devops/podman/start-pod.sh
  ```
- **Windows:**
  ```cmd
  devops\podman\start-pod.bat
  ```

Para parar o Pod nativo:
```bash
./devops/podman/stop-pod.sh
# ou no Windows:
devops\podman\stop-pod.bat
```

---

### Modo 2: Podman Compose
Se você possui o utilitário `podman-compose` instalado:

- **Linux / macOS:**
  ```bash
  ./devops/podman/start-compose.sh
  ```
- **Windows:**
  ```cmd
  devops\podman\start-compose.bat
  ```

---

## 🌐 URLs de Acesso

- **Urna Eletrônica:** [http://localhost:8080/frontend/index.html](http://localhost:8080/frontend/index.html)
- **Apuração ao Vivo:** [http://localhost:8080/frontend/apuracao.html](http://localhost:8080/frontend/apuracao.html)
- **API REST Backend:** [http://localhost:8080/backend/apuracao](http://localhost:8080/backend/apuracao)

---

## 💡 Dicas Específicas do Podman

- **Segurança Rootless & SELinux:** O volume possui o sufixo `:Z` no `podman-compose.yml` e nos scripts para garantir que os rótulos SELinux (comuns no Fedora/RHEL/CentOS) permitam gravação sem conflitos de permissão.
- **Gerar manifesto Kubernetes direto do Podman:**
  Com o pod rodando, execute `./devops/podman/generate-kube.sh` para obter o YAML compatível com qualquer cluster Kubernetes!

---

## 🔄 Deploy Automático via Git

### 1. Via Script de Atualização (`deploy-git.sh` / `deploy-git.bat`)
```bash
./devops/podman/deploy-git.sh main
```
Atualiza o código do Git, reconstrói as imagens no Podman e recarrega os containers/pods sem interrupção.

### 2. Via Git Push no Servidor (Git Hook `post-receive`)
Configure o hook [git-hook-post-receive](git-hook-post-receive) em um repositório Git Bare no servidor. A cada `git push production main`, o servidor atualizará a aplicação e os pods automaticamente.

### 3. Via GitHub Actions CI/CD
O workflow [.github/workflows/podman-ci-cd.yml](../../.github/workflows/podman-ci-cd.yml) compila a imagem via Podman a cada push na branch `main`, envia para o GitHub Packages (GHCR) e pode acionar deploy via SSH.

