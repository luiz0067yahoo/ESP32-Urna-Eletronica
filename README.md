# 🗳️ POKE Urna Eletrônica • Eleições Pokémon 2026

Simulador e sistema completo de **Urna Eletrônica Brasileira** com temática **Pokémon**, desenvolvido para integração com microcontrolador **POKE** e navegação web. O projeto conta com interface interativa de votação, API RESTful em PHP/MySQL para contagem de votos, e painel de apuração em tempo real inspirado em gráficos de transmissão eleitoral de televisão.

---

## 🌐 Demonstração Online

Acesse a aplicação em produção diretamente no GitHub Pages:

👉 **[https://luiz0067yahoo.github.io/ESP32-Urna-Eletronica/frontend](https://luiz0067yahoo.github.io/ESP32-Urna-Eletronica/frontend)**

---

## 📸 Capturas de Tela

### 1. Cabine de Votação (Urna Eletrônica)
Interface fiel à urna eletrônica do TSE com visor digital, colinha eleitoral e teclado numérico interativo (compatível com POKE via teclado matricial).

![Urna Eletrônica](docs/urna_eletronica.png)

### 2. Apuração em Tempo Real • Presidente do Brasil
Layout no formato de noticiário de televisão: barras verticais proporcionais, fotos circulares oficiais dos Pokémons, percentuais ao vivo, total de urnas apuradas e relógio digital dinâmico.

![Apuração Presidente](docs/apuracao_presidente.png)

### 3. Apuração em Tempo Real • Governador do Estado
Navegação entre cargos eletivos com destaque para os líderes na corrida eleitoral e lista completa dos candidatos.

![Apuração Governador](docs/apuracao_governador.png)

---

## 📁 Estrutura do Projeto e Descrição dos Arquivos

Abaixo está o detalhamento completo de todos os arquivos e pastas que compõem o repositório:

```
ESP32-Urna-Eletronica/
├── .gitattributes                # Configurações de atributos do Git
├── .gitignore                    # Arquivos e pastas ignorados no controle de versão
├── .htaccess                     # Regras do servidor Apache para redirecionamento à pasta frontend
├── README.md                     # Documentação oficial do projeto
│
├── frontend/                     # Interface Web do Usuário
│   ├── index.html                # Tela principal de votação da Urna Eletrônica
│   ├── apuracao.html             # Tela de Apuração de Votos em Tempo Real (estilo noticiário de TV)
│   ├── urna.js                   # Cópia raiz do script de controle da urna
│   │
│   ├── css/                      # Folhas de estilo da aplicação
│   │   ├── style.css             # Estilos gerais e variáveis da interface
│   │   ├── urna.css              # Estilos do gabinete da urna, tela LCD e teclado numérico
│   │   ├── apuracao.css          # Estilos do card eleitoral (fundo bege, barras verticais e relógio)
│   │   └── santinhos.css         # Estilização do modal com os santinhos dos candidatos
│   │
│   └── js/                       # Scripts de lógica no cliente
│       ├── urna.js               # Gerenciador da urna (digitação, validação de etapas, sons e envio de votos)
│       ├── apuracao.js           # Gerenciador da apuração (polling automático de 5s, cruzamento de dados e gráficos)
│       ├── partidos.js           # Cadastro dos partidos políticos temáticos (siglas, nomes e propostas)
│       │
│       ├── candidatos/           # Base de candidatos dividida por cargo eletivo
│       │   ├── candidato.js      # Classe modelo Candidato (número, nome, partido, foto, vice)
│       │   ├── presidentes.js    # Candidatos a Presidente (Pikachu, Squirtle, Charmander)
│       │   ├── governadores.js   # Candidatos a Governador (Manectric, Zapdos, Blaziken, etc.)
│       │   ├── senadores_1.js    # Candidatos a 1º Senador (Alakazam, Gengar, Dragonite, etc.)
│       │   ├── senadores_2.js    # Candidatos a 2º Senador (Mewtwo, Lugia, Ho-Oh, etc.)
│       │   ├── senadores.js      # Lista consolidada de senadores
│       │   ├── deputados_federais.js  # Candidatos a Deputado Federal (Raichu, Charizard, etc.)
│       │   └── deputados_estaduais.js # Candidatos a Deputado Estadual (Pichu, Cyndaquil, etc.)
│       │
│       └── artes/                # Ilustrações e artes complementares dos candidatos
│           ├── ARTES_PRESIDENTES.js
│           ├── ARTES_GOVERNADORES.js
│           ├── ARTES_SENADORES_1.js
│           ├── ARTES_SENADORES_2.js
│           ├── ARTES_DEPUTADOS_FEDERAIS.js
│           └── ARTES_DEPUTADOS_ESTADUAIS.js
│
├── backend/                      # API RESTful em PHP e Conexão com Banco de Dados
│   ├── index.php                 # Roteador central da API RESTful (rotas /votos e /apuracao)
│   ├── route.php                 # Classe utilitária Route para gerenciamento e despacho de rotas HTTP
│   ├── conecta.php               # Gerenciador de conexão PDO com MySQL com leitura de arquivo .env
│   ├── .env                      # Arquivo de configuração de credenciais do banco (local/produção)
│   ├── .env.example              # Exemplo de configuração de variáveis de ambiente
│   ├── .htaccess                 # Reescrita de URLs para rotas amigáveis da API REST
│   │
│   ├── apuracao/
│   │   └── index.php             # Endpoint alternativo para compatibilidade sem mod_rewrite
│   │
│   └── votos/
│       └── index.php             # Endpoint alternativo para registro e consulta de votos
│
├── db/                           # Scripts PHP de Banco de Dados (Migração, Seed e Instalador)
│   ├── install.php               # Instalador inteligente: verifica se já foi migrado e se o seed existe antes de executar
│   ├── migrate.php               # Criação das tabelas 'votos', 'partidos' e 'candidatos' via string SQL
│   └── seed.php                  # Povoamento inicial de partidos, candidatos e votos de teste via string SQL
│
├── devops/                       # Configurações Piku e Scripts Nativos (100% Sem Docker)
│   ├── Procfile                  # Declaração dos processos gerenciados pelo Piku
│   ├── ENV                       # Variáveis de ambiente padrão do Piku
│   ├── nginx.conf                # Configuração do Nginx para servidor de produção / Piku
│   ├── setup_db.sh / .bat        # Scripts para provisionamento automático do banco MySQL
│   ├── start.sh / .bat           # Inicializadores em 1 clique (sobe MySQL, Frontend e Backend)
│   └── README.md                 # Guia detalhado de deploy no Piku
│
├── Procfile                      # Procfile na raiz para deploy padrão com git push piku main
│
└── docs/                         # Capturas de tela e documentação visual
    ├── urna_eletronica.png       # Screenshot da cabine de votação
    ├── apuracao_presidente.png   # Screenshot da apuração para Presidente
    └── apuracao_governador.png   # Screenshot da apuração para Governador
```

---

## 🗄️ Banco de Dados (Instalador Inteligente, Migração e Seed)

A pasta `db/` fornece scripts em PHP contendo todo o código SQL armazenado em strings (`$sqlMigrate` e `$sqlSeed`), além do instalador idempotente `install.php`:

### 1. Instalação e Verificação em 1 Passo (Recomendado):
O arquivo `db/install.php` verifica automaticamente se as tabelas já foram criadas e se os registros de candidatos/partidos já foram semeados, evitando duplicações:
```bash
# Executa verificação, migração e seed automaticamente
php db/install.php
```
Ou acesse pelo navegador: `http://localhost:8080/db/install.php` (adicione `?format=json` para resposta em JSON).

### 2. Execução Individual dos Módulos:
```bash
# Executa apenas a criação das tabelas
php db/migrate.php

# Executa apenas o povoamento dos candidatos e votos
php db/seed.php
```

---

## 🚀 Como Executar Localmente

### Pré-requisitos:
- Servidor Web Apache/Nginx ou PHP CLI 7.4+ / 8.x nativo (ex: XAMPP, WampServer ou inicializador nativo sem Docker).
- Banco de Dados MySQL / MariaDB nativo.

### Passo a Passo:
1. Clone este repositório no diretório do seu servidor web ou pasta de preferência:
   ```bash
   git clone https://github.com/luiz0067yahoo/ESP32-Urna-Eletronica.git
   ```
2. Configure o arquivo `backend/.env` (o sistema utiliza preferencialmente `backend/.env`, com fallback automático para `backend/.env.example` caso não exista):
   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASS=
   DB_NAME=urna_eletronica
   ```
3. Execute o instalador do banco de dados (cria o schema e semeia os dados caso ainda não existam):
   ```bash
   php db/install.php
   ```
   *(Ou no Windows via terminal/cmd executando `devops\setup_db.bat`)*
4. Abra o navegador em:
   - **Urna Eletrônica:** `http://localhost:8080/frontend/index.html`
   - **Apuração dos Votos:** `http://localhost:8080/frontend/apuracao.html`

---

## ⚡ Integração com POKE

O backend foi projetado para receber comandos e votos tanto da interface web quanto de um microcontrolador **POKE**:
- O POKE realiza requisições HTTP `POST` para o endpoint `/backend/votos` enviando o payload JSON:
  ```json
  {
    "cargo": "PRESIDENTE",
    "numero_candidato": "65"
  }
  ```
- O teclado físico de 12 ou 16 teclas conectado aos pinos GPIO do POKE envia os números digitados, confirmação e correção.
- A tela de apuração reflete automaticamente a contagem a cada 5 segundos.

---

## 📄 Licença

Projeto desenvolvido para fins educacionais e de demonstração. Ilustrações de Pokémon são propriedade de Nintendo / Game Freak / The Pokémon Company obtidas através da [PokeAPI](https://pokeapi.co/).
