# 🛠️ DevOps • Piku & Execução Nativa (100% Sem Docker)

Esta pasta contém as configurações para o **Piku** (PaaS minimalista que executa aplicações diretamente no sistema operacional sem necessidade de Docker/containers) e scripts de inicialização completa do **Frontend**, **Backend** e **Banco de Dados MySQL**.

---

## 📁 Arquivos da Pasta DevOps

| Arquivo | Função |
| :--- | :--- |
| `Procfile` | Declaração dos processos que o **Piku** gerencia nativamente (`web: php -S 0.0.0.0:$PORT -t .`). |
| `ENV` | Variáveis de ambiente lidas pelo Piku na inicialização (`PORT`, `DB_HOST`, `DB_NAME`, etc.). |
| `nginx.conf` | VirtualHost para Nginx em servidores de produção com suporte a PHP-FPM e rotas da API REST. |
| `setup_db.sh` | Script Linux/macOS para criar o banco de dados MySQL e rodar `db/migrate.sql` e `db/seed.sql`. |
| `setup_db.bat` | Script Windows para provisionar o banco de dados MySQL local. |
| `start.sh` | Inicializador em 1 clique para Linux/macOS: checa MySQL, executa seed e inicia o servidor web na porta `8080`. |
| `start.bat` | Inicializador em 1 clique para Windows: verifica MySQL e inicia o servidor web abrindo o navegador. |

---

## 🚀 Como Iniciar Tudo Localmente (Sem Docker)

### No Windows:
Basta dar dois cliques no arquivo:
```cmd
devops\start.bat
```
Ou via Prompt / PowerShell:
```powershell
.\devops\start.bat
```

### No Linux / macOS:
```bash
chmod +x devops/*.sh
./devops/start.sh
```

O comando irá:
1. Verificar e conectar ao serviço MySQL local.
2. Executar as migrações e o seed de candidatos se necessário.
3. Subir o servidor unificado em `http://localhost:8080/`.

---

## ☁️ Deploy no Piku (PaaS Sem Docker)

O [Piku](https://github.com/piku/piku) funciona como um Heroku/Dokku próprio que roda em qualquer VPS Linux ou Raspberry Pi sem Docker, consumindo pouquíssima memória.

### 1. Criar o aplicativo no servidor Piku:
```bash
ssh piku@seu-servidor.com apps:create urna-eletronica
```

### 2. Configurar as variáveis de ambiente:
```bash
ssh piku@seu-servidor.com config:set urna-eletronica DB_HOST=localhost DB_NAME=urna_eletronica DB_USER=root DB_PASS=suasenha PORT=8080
```

### 3. Fazer o Deploy via Git:
No seu repositório local:
```bash
git remote add piku piku@seu-servidor.com:urna-eletronica
git push piku main
```

O Piku lerá automaticamente o arquivo `Procfile` e o arquivo `ENV`, subindo o serviço de forma nativa e gerenciando os processos em segundo plano!
