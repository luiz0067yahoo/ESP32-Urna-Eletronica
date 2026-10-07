# 🗳️ ESP32 Urna Eletrônica • Eleições Pokémon 2026

Simulador e sistema completo de **Urna Eletrônica Brasileira** com temática **Pokémon**, desenvolvido para integração com microcontrolador **ESP32** e navegação web. O projeto conta com interface interativa de votação, API RESTful em PHP/MySQL para contagem de votos, e painel de apuração em tempo real inspirado em gráficos de transmissão eleitoral de televisão.

---

## 🌐 Demonstração Online

Acesse a aplicação em produção diretamente no GitHub Pages:

👉 **[https://luiz0067yahoo.github.io/ESP32-Urna-Eletronica/frontend](https://luiz0067yahoo.github.io/ESP32-Urna-Eletronica/frontend)**

---

## 📸 Capturas de Tela

### 1. Cabine de Votação (Urna Eletrônica)
Interface fiel à urna eletrônica do TSE com visor digital, colinha eleitoral e teclado numérico interativo (compatível com ESP32 via teclado matricial).

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
├── db/                           # Scripts de Banco de Dados (Migração e Seed)
│   ├── migrate.sql               # DDL de criação das tabelas 'votos', 'partidos' e 'candidatos'
│   ├── seed.sql                  # DML de povoamento inicial de partidos, candidatos e votos de teste
│   ├── migrate.php               # Script executável via CLI/Web para aplicar o migrate.sql
│   └── seed.php                  # Script executável via CLI/Web para aplicar o seed.sql
│
└── docs/                         # Capturas de tela e documentação visual
    ├── urna_eletronica.png       # Screenshot da cabine de votação
    ├── apuracao_presidente.png   # Screenshot da apuração para Presidente
    └── apuracao_governador.png   # Screenshot da apuração para Governador
```

---

## 🗄️ Banco de Dados (Migração e Povoamento)

A pasta `db/` fornece tanto os scripts SQL quanto executáveis em PHP para provisionar o banco de dados MySQL:

### 1. Execução via CLI (Linha de comando PHP):
```bash
# Executa a criação das tabelas (votos, partidos e candidatos)
php db/migrate.php

# Insere os partidos, candidatos oficiais e votos de demonstração
php db/seed.php
```

### 2. Execução direta via MySQL / phpMyAdmin:
- Importe o arquivo `db/migrate.sql` para criar as tabelas.
- Importe o arquivo `db/seed.sql` para preencher os registros iniciais.

---

## 🚀 Como Executar Localmente

### Pré-requisitos:
- Servidor Web Apache/Nginx com suporte a PHP 7.4+ ou 8.x (ex: XAMPP, WampServer ou Docker).
- Banco de Dados MySQL / MariaDB.

### Passo a Passo:
1. Clone este repositório no diretório público do seu servidor web (ex: `htdocs`):
   ```bash
   git clone https://github.com/luiz0067yahoo/ESP32-Urna-Eletronica.git
   ```
2. Configure o arquivo `backend/.env` com as credenciais do seu banco de dados MySQL:
   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASS=
   DB_NAME=urna_eletronica
   ```
3. Execute as migrações:
   ```bash
   php db/migrate.php
   php db/seed.php
   ```
4. Abra o navegador em:
   - **Urna Eletrônica:** `http://localhost/ESP32-Urna-Eletronica/frontend/index.html`
   - **Apuração dos Votos:** `http://localhost/ESP32-Urna-Eletronica/frontend/apuracao.html`

---

## ⚡ Integração com ESP32

O backend foi projetado para receber comandos e votos tanto da interface web quanto de um microcontrolador **ESP32**:
- O ESP32 realiza requisições HTTP `POST` para o endpoint `/backend/votos` enviando o payload JSON:
  ```json
  {
    "cargo": "PRESIDENTE",
    "numero_candidato": "65"
  }
  ```
- O teclado físico de 12 ou 16 teclas conectado aos pinos GPIO do ESP32 envia os números digitados, confirmação e correção.
- A tela de apuração reflete automaticamente a contagem a cada 5 segundos.

---

## 📄 Licença

Projeto desenvolvido para fins educacionais e de demonstração. Ilustrações de Pokémon são propriedade de Nintendo / Game Freak / The Pokémon Company obtidas através da [PokeAPI](https://pokeapi.co/).
