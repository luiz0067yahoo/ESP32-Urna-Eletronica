# 🐳 DevOps • Docker & Docker Compose

Configurações prontas para executar a **Urna Eletrônica Pokémon** em containers Docker com inicialização automatizada de banco de dados e migrações.

---

## 📁 Estrutura desta pasta

| Arquivo | Descrição |
| :--- | :--- |
| `Dockerfile` | Imagem Apache + PHP 8.2 com extensões PDO MySQL e suporte a `mod_rewrite`. |
| `docker-entrypoint.sh` | Script que aguarda o MySQL ficar saudável e roda automaticamente o `php db/install.php`. |
| `docker-compose.yml` | Orquestração dos serviços: Aplicação Web (`urna_app`), Banco MariaDB (`urna_db`) e phpMyAdmin (`urna_phpmyadmin`). |
| `.env.example` | Variáveis de configuração padrão (portas, senhas e nomes de banco). |
| `start.sh` / `start.bat` | Scripts de inicialização em 1 clique (Linux/macOS e Windows). |
| `stop.sh` / `stop.bat` | Scripts para parar e encerrar os containers. |
| `deploy-git.sh` / `.bat` | **Deploy Automático via Git:** Faz `git pull`, reconstrói containers, aplica migrações e limpa imagens antigas. |
| `git-hook-post-receive` | Git Hook para servidores: ao executar `git push production main`, o servidor atualiza e recarrega os containers automaticamente. |

---

## 🚀 Como Iniciar

### Opção 1: Via Scripts Automáticos

- **No Windows:** Dê dois cliques em `start.bat` ou execute:
  ```cmd
  devops\docker\start.bat
  ```

- **No Linux / macOS:**
  ```bash
  chmod +x devops/docker/*.sh
  ./devops/docker/start.sh
  ```

### Opção 2: Manualmente com Docker Compose

Dentro da pasta `devops/docker`:
```bash
docker compose up -d --build
```

---

## 🌐 URLs de Acesso

Assim que os containers estiverem em execução:

- **Urna Eletrônica:** [http://localhost:8080/frontend/index.html](http://localhost:8080/frontend/index.html)
- **Apuração ao Vivo:** [http://localhost:8080/frontend/apuracao.html](http://localhost:8080/frontend/apuracao.html)
- **API REST Backend:** [http://localhost:8080/backend/apuracao](http://localhost:8080/backend/apuracao)
- **phpMyAdmin:** [http://localhost:8081](http://localhost:8081)  
  - *Usuário:* `root`  
  - *Senha:* `rootpassword` (ou `urna` / `urna123`)

---

## 🛠️ Comandos Úteis

- **Ver logs em tempo real:**
  ```bash
  docker compose logs -f
  ```
- **Acessar o terminal do container da aplicação:**
  ```bash
  docker compose exec app bash
  ```
- **Reexecutar migração e seed manualmente:**
  ```bash
  docker compose exec app php db/install.php
  ```
- **Parar e remover volumes (resetar dados do banco):**
  ```bash
  docker compose down -v
  ```

---

## 🔄 Deploy Automático via Git

Existem duas formas suportadas de deploy automático:

### 1. Via Script de Atualização (`deploy-git.sh` / `deploy-git.bat`)
Útil para ambientes de staging/produção ou servidores CI:
```bash
./devops/docker/deploy-git.sh main
```
O script busca o código mais recente no Git, reconstrói as imagens necessárias, recarrega os containers sem interrupção e aplica automaticamente qualquer migração pendente no banco.

### 2. Via Git Push Direto no Servidor (Git Hook `post-receive`)
Para fazer deploy rodando simplesmente `git push production main`:
1. No seu servidor, crie um repositório Git Bare:
   ```bash
   mkdir -p /home/deploy/urna.git && cd /home/deploy/urna.git
   git init --bare
   ```
2. Copie o script [git-hook-post-receive](file:///c:/Users/10345/Documents/GitHub/ESP32%20Urna%20Eletronica/devops/docker/git-hook-post-receive) para `/home/deploy/urna.git/hooks/post-receive`:
   ```bash
   chmod +x /home/deploy/urna.git/hooks/post-receive
   ```
3. Na sua máquina de desenvolvimento local:
   ```bash
   git remote add production deploy@seu-servidor.com:/home/deploy/urna.git
   git push production main
   ```
O servidor receberá o push e atualizará os containers Docker automaticamente!

### 3. Via GitHub Actions CI/CD
O workflow [.github/workflows/docker-ci-cd.yml](file:///c:/Users/10345/Documents/GitHub/ESP32%20Urna%20Eletronica/.github/workflows/docker-ci-cd.yml) compila a imagem Docker a cada push na branch `main`, publica no GitHub Packages (GHCR) e opcionalmente executa o deploy remoto via SSH.

