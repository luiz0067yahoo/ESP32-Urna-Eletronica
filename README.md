# 🗳️ Pokémon Electronic Voting Machine • 2026 Elections

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

<br/>

![Project Status](https://img.shields.io/badge/Status-100%25%20Operational-success?style=for-the-badge&logo=checkmarx)
![Architecture](https://img.shields.io/badge/Architecture-100%25%20Web-blue?style=for-the-badge&logo=html5)
![PHP](https://img.shields.io/badge/PHP-7.4%20%7C%208.x-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-5.7%20%7C%208.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Vanilla%20ES6+-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Hosting](https://img.shields.io/badge/Deploy-cPanel%20%7C%20Hostinger%20%7C%20Apache-E65100?style=for-the-badge&logo=apache)

**Complete electronic voting system inspired by the official standards of the Brazilian Superior Electoral Court (TSE) with a Pokémon theme.**  
Built on a 100% Web architecture (HTML5, CSS3, Vanilla JavaScript + RESTful PHP API + MySQL/MariaDB).

[🌐 Live Online Demo](http://urna.gamer.free) • [📖 Hosting Guide](#-traditional-hosting-deployment-cpanel--hostinger--locaweb) • [🧪 Test Suite](#-test-suite--simulators-tests) • [🔌 API Documentation](#-restful-api-documentation)

</div>

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Screenshots and System Demo](#-screenshots-and-system-demo)
- [Key Features](#-key-features)
- [Repository Structure](#-repository-structure)
- [Traditional Hosting Deployment (cPanel / Hostinger / Locaweb)](#-traditional-hosting-deployment-cpanel--hostinger--locaweb)
- [Local Execution (XAMPP / WampServer / PHP CLI)](#-local-execution)
- [Database & Official Seed Data](#-database--official-seed-data)
- [RESTful API Documentation](#-restful-api-documentation)
- [Test Suite & Simulators (`tests/`)](#-test-suite--simulators-tests)
- [DevOps and Containers (Optional)](#-devops-and-containers-optional)
- [License and Credits](#-license)

---

## ⚡ Quick Start (start.bat / start.sh)

The project includes a unified interactive root menu to launch any environment with 1 click:

- **On Windows:** Double-click [`start.bat`](start.bat) (or run `start.bat` in CMD/PowerShell).
- **On Linux / macOS:** Run in your terminal:
  ```bash
  chmod +x start.sh
  ./start.sh
  ```

The menu dynamically lets you select:
```
 [1] 🐳 Docker Compose      (Starts Apache + PHP + MariaDB + phpMyAdmin)
 [2] 🦭 Podman Compose      (Containers via Podman)
 [3] ☸️ Kubernetes          (Deploy K8s Manifests / Ingress)
 [4] 🐘 Local PHP + MySQL   (PHP Built-in Server / XAMPP)
 [5] 🛑 Stop Services       (Shuts down Docker, Podman, or Local PHP)
 [0] ❌ Exit
```

---

## 🔍 Overview

The **Pokémon Electronic Voting Machine** faithfully replicates the authentic civic voting experience:
- **Digital Voting Booth:** High-precision numeric keypad interface, electronic LCD screen, candidate portraits, electoral cheat sheet, and signature sound effects (keypad beep and official end-of-vote chime).
- **Real-Time Vote Tallying Dashboard:** Broadcast-inspired dashboard showcasing proportional vertical bars, live digital clock, polling station progress, and official candidate artwork.
- **Robust & Lightweight Backend:** Modular RESTful PHP API compatible with any shared hosting provider, zero heavy framework dependencies, and native MySQL/MariaDB support.

---

## 📸 Screenshots and System Demo

### 1. Voting Booth (Electronic Ballot Box)
*Digital display, interactive `BRANCO` (Blank), `CORRIGE` (Correct), and `CONFIRMA` (Confirm) buttons, Web Audio API feedback, and full 6-office election flow.*

![Voting Booth](docs/urna_eletronica.png)

### 2. Live Results Tally • President of the Republic
*Vertical charts featuring official PokeAPI artwork, live percentage calculation, and visual highlighting for vote leaders.*

![President Results](docs/apuracao_presidente.png)

### 3. Live Results Tally • State Governor
*Dynamic navigation between elective offices (President, Governor, 1st & 2nd Senators, Federal Representative, State Representative).*

![Governor Results](docs/apuracao_governador.png)

---

## ✨ Key Features

- 🗳️ **Official 6-Office Electoral Workflow:**
  1. State Representative *(5 digits)*
  2. Federal Representative *(4 digits)*
  3. 1st Senator *(3 digits)*
  4. 2nd Senator *(3 digits)*
  5. State Governor *(2 digits)*
  6. President of the Republic *(2 digits)*
- ⌨️ **Software Input Validator:** Strict digit mask control, `BRANCO` (Blank vote), `CORRIGE` (Correction/Reset), and `CONFIRMA` (Commit vote).
- 🔊 **Authentic Sound Effects:** Synthesized audio via Web Audio API reproducing real key clicks and the signature electoral completion chime.
- 📡 **Resilient Vote Dispatch:** Automatic transmission via HTTP `POST` requests with graceful local offline fallback.
- 🔄 **Dynamic Live Polling:** Results tallying screen synchronizes with the database every 5 seconds without full page refreshes.

---

## 📁 Repository Structure

```text
ESP32-Urna-Eletronica/
│
├── start.bat                     # ⚡ Central Windows Launcher (Docker, Podman, K8s, Local PHP)
├── start.sh                      # 🐧 Central Linux/macOS Launcher
├── .env.example                  # 🔐 Centralized environment variables template (Root, Backend, DevOps)
├── .htaccess                     # ⚙️ Apache Rules (URL rewrite to frontend/ and security headers)
├── README.md                     # 📖 Official Documentation (English)
├── README.pt.md                  # 📖 Portuguese Documentation
├── README.es.md                  # 📖 Spanish Documentation
├── README.it.md                  # 📖 Italian Documentation
│
├── frontend/                     # 🌐 Client Web Application
│   ├── index.html                # Electronic Voting Machine (Voting Booth)
│   ├── apuracao.html             # Real-Time Vote Tallying Dashboard
│   ├── urna.js                   # Voting booth compatibility entrypoint
│   ├── css/                      # Responsive and thematic design stylesheets
│   │   ├── style.css             # Global typography and base layout
│   │   ├── urna.css              # Ballot box cabinet, LCD display, keypad
│   │   ├── apuracao.css          # TV broadcast scoreboard style, vertical bars
│   │   └── santinhos.css         # Candidate cheat sheet modal dialog
│   └── js/                       # Core voting logic and electoral rules
│       ├── urna.js               # Ballot box controller (digit mask, audio, HTTP dispatch)
│       ├── apuracao.js           # Results controller (polling, charts, percentage computation)
│       ├── partidos.js           # Official Pokémon political party registry
│       ├── candidatos/           # Modular candidate registries per elective office
│       │   ├── candidato.js      # Candidate data model
│       │   ├── presidentes.js    # Presidential candidates
│       │   ├── governadores.js   # Gubernatorial candidates
│       │   ├── senadores_1.js    # 1st Senatorial candidates
│       │   ├── senadores_2.js    # 2nd Senatorial candidates
│       │   ├── deputados_federais.js  # Federal Representative candidates
│       │   └── deputados_estaduais.js # State Representative candidates
│       └── artes/                # High-resolution PokeAPI candidate artwork
│
├── backend/                      # ⚙️ RESTful PHP API
│   ├── index.php                 # Central API router (/votos, /apuracao, /status)
│   ├── route.php                 # Standalone lightweight HTTP router engine
│   ├── conecta.php               # PDO MySQL database connection manager (reads config.php / .env)
│   ├── config.example.php        # Configuration template for shared web hosting
│   ├── .htaccess                 # Clean URL rewrite rules
│   ├── votos/index.php           # Direct voting endpoint (compatible without mod_rewrite)
│   └── apuracao/index.php        # Direct results endpoint (compatible without mod_rewrite)
│
├── db/                           # 🗄️ MySQL Database (100% PHP • Zero .sql files)
│   ├── install.php               # Smart installer (runs migrations & seeds via PHP)
│   ├── migrate.php               # Migration runner (invokes db/migrate/index.php)
│   ├── seed.php                  # Seed runner (invokes db/seed/index.php)
│   │
│   ├── migrate/                  # 🛠️ Individual Table Migrations (100% PHP)
│   │   ├── partidos.php          # PHP script creating 'partidos' table
│   │   ├── candidatos.php        # PHP script creating 'candidatos' table
│   │   ├── votos.php             # PHP script creating 'votos' table
│   │   └── index.php             # PHP runner executing all migrations
│   │
│   └── seed/                     # 🌱 Individual Table Seeders (100% PHP)
│       ├── partidos.php          # PHP seed populating political parties
│       ├── candidatos.php        # PHP seed populating official candidates
│       ├── votos.php             # PHP seed generating initial demo votes
│       └── index.php             # PHP runner executing all seeders
│
├── tests/                        # 🧪 Test Suite, Simulators & Audit (100% PHP)
│   ├── index.html                # Visual browser test dashboard with stress test controls
│   ├── test_sistema_api.php      # Automated REST API contract test suite (PHP CLI / Web)
│   ├── simulador_poke.php        # Digital Voting Terminal Simulator (PHP voting client)
│   ├── simulador_eleicao_massa.php # Load & stress test simulator (async HTTP concurrency via curl_multi)
│   ├── simulador_teclado_matricial.php # Keypad validator & digit rule auditor
│   ├── run_tests.bat             # 1-click test launcher for Windows (PHP CLI)
│   ├── run_tests.sh              # Executable test launcher for Linux / macOS (PHP CLI)
│   └── README.md                 # Detailed tests documentation
│
├── devops/                       # 🐳 Containers & Infrastructure (Optional)
│   ├── docker/                   # Dockerfile and docker-compose.yml (Apache + PHP 8.2 + MariaDB)
│   ├── podman/                   # Containerfile and podman-compose
│   └── kubernetes/               # Kubernetes Deployment, Service, and Ingress manifests
│
└── docs/                         # 🖼️ Documentation visual assets
    ├── urna_eletronica.png
    ├── apuracao_presidente.png
    └── apuracao_governador.png
```

---

## 🌐 Traditional Hosting Deployment (cPanel / Hostinger / Locaweb)

The project is specifically built to deploy on **any shared web hosting provider** with **HTML, CSS, JS, PHP (7.4 or 8.x), and MySQL / MariaDB**.

### Step 1: Upload Project Files
1. Compress project files into a `.zip` archive or connect via **FTP (FileZilla)**.
2. Extract all files into your public web root directory (commonly **`public_html`** or **`www`**).

### Step 2: Create MySQL Database via Hosting Control Panel
1. In your hosting dashboard (cPanel, hPanel, etc.), navigate to **MySQL Databases**.
2. Create a new database (e.g., `user_urna`).
3. Create a new MySQL user with a strong password and assign it to the database with **ALL PRIVILEGES**.

### Step 3: Configure Database Credentials
Inside `backend/`, create a file named **`config.php`** (you can copy [`backend/config.example.php`](backend/config.example.php)):

```php
<?php
// MySQL Database Configuration
define('DB_HOST', 'localhost');          // Usually 'localhost' on shared hosting
define('DB_NAME', 'your_database_name'); // Database name created in cPanel
define('DB_USER', 'your_database_user'); // MySQL user created in cPanel
define('DB_PASS', 'your_secret_password'); // MySQL user password
define('DB_PORT', '3306');
```
*(If your hosting environment supports `.env`, you can alternatively fill in `backend/.env`)*.

### Step 4: Run Migrations and Seeds (100% PHP)
No SQL file import is required. Table creation and candidate population happen entirely through PHP scripts:
- **Via Web Browser (Easiest):**
  Open in your browser:
  `https://yourdomain.com/db/install.php`
- **Via Terminal / SSH:**
  ```bash
  php db/install.php
  ```

### Step 5: Access the Application
- 🗳️ **Voting Booth:** `https://yourdomain.com/` *(routed via `.htaccess` to `/frontend/index.html`)*
- 📊 **Live Results Tally:** `https://yourdomain.com/apuracao` *(or `/frontend/apuracao.html`)*
- 🔌 **RESTful Voting API:** `https://yourdomain.com/backend/votos`

---

## 💻 Local Execution

### Prerequisites:
- Local stack such as **XAMPP**, **WampServer**, **Laragon**, or **Native PHP (CLI)**.
- MySQL or MariaDB running on port 3306.

### Step-by-Step:
1. Clone the repository into your local web root (e.g., `htdocs` in XAMPP or `www` in Wamp):
   ```bash
   git clone https://github.com/luiz0067yahoo/ESP32-Urna-Eletronica.git
   ```
2. Create the `urna` database in MySQL:
   ```sql
   CREATE DATABASE urna CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Set your local credentials in `backend/config.php` or `backend/.env` (default is `root` with empty password).
4. Run the automated installer:
   ```bash
   php db/install.php
   ```
5. Access in your browser:
   - Voting Booth: `http://localhost/ESP32-Urna-Eletronica/`
   - Results Tally: `http://localhost/ESP32-Urna-Eletronica/apuracao` *(or `frontend/apuracao.html`)*

*(Or launch using the built-in PHP server via `start.bat` / `start.sh` option [4]).*

---

## 🗄️ Database & Official Seed Data

The database uses three relational tables optimized with indexes:

### 1. `partidos`
Contains themed Pokémon political parties:
| Acronym | Party Name | Slogan |
| :--- | :--- | :--- |
| **POKPELE** | Partido Organizado Karvalho Professor Elétrico | Energy and innovation for everyone |
| **POKPFGO** | Partido Organizado Karvalho Professor Fogo | Flame of transformation |
| **POKPAGU** | Partido Organizado Karvalho Professor Água | Water is life and conservation |
| **POKPPSI** | Partido Organizado Karvalho Professor Psíquico | Knowledge, science, and wisdom |
| *...* | *Other themed parties* | *...* |

### 2. `candidatos`
Contains all official candidates per office:
- **President:** Pikachu (65), Squirtle (63), Charmander (62).
- **Governor:** Manectric (81), Zapdos (82), Magmortar (84), Blaziken (85), Feraligatr (87), Greninja (88), etc.
- **Senator:** Alakazam (701), Gengar (702), Dragonite (703), Mewtwo (751), Lugia (752), Ho-Oh (753).
- **Federal Representative:** Raichu (9101), Jolteon (9102), Charizard (9201), Blastoise (9301).
- **State Representative:** Pichu (90101), Mareep (90102), Cyndaquil (90201), Totodile (90301).

### 3. `votos`
Records individual ballot submissions with timestamps and office identifiers.

---

### 📂 Modular Migrations & Seeders (100% PHP)

Built with a modular architecture driven by **pure PHP scripts** (zero `.sql` files):

#### A) Individual Migrations (`db/migrate/`)
Creates table schemas via PHP:
- **Parties:** `php db/migrate/partidos.php`
- **Candidates:** `php db/migrate/candidatos.php`
- **Votes:** `php db/migrate/votos.php`
- **All Migrations together:** `php db/migrate/index.php` *(or `php db/migrate.php`)*

#### B) Individual Seeders (`db/seed/`)
Populates initial datasets via PHP:
- **Parties:** `php db/seed/partidos.php`
- **Candidates:** `php db/seed/candidatos.php`
- **Votes:** `php db/seed/votos.php`
- **All Seeders together:** `php db/seed/index.php` *(or `php db/seed.php`)*

#### C) Complete Smart Installer
- **Unified Installer:** `php db/install.php` (or visit `https://yourdomain.com/db/install.php` in your browser to verify, migrate, and seed in one step).

---

## 🔌 RESTful API Documentation

All responses return standard `JSON` encoded in `UTF-8`.

### 1. Cast Individual Ballot
- **Endpoint:** `POST /backend/votos`
- **Headers:** `Content-Type: application/json`
- **Payload:**
  ```json
  {
    "cargo": "PRESIDENTE",
    "numero_candidato": "65"
  }
  ```
- **Response (HTTP 201):**
  ```json
  {
    "status": "success",
    "message": "Voto para PRESIDENTE computado com sucesso!",
    "id": 142
  }
  ```

### 2. Cast Complete Batch Ballot Session
- **Endpoint:** `POST /backend/votos`
- **Payload:**
  ```json
  {
    "votos": [
      { "cargo": "DEPUTADO ESTADUAL", "numero_candidato": "90101" },
      { "cargo": "DEPUTADO FEDERAL", "numero_candidato": "9101" },
      { "cargo": "1º SENADOR", "numero_candidato": "701" },
      { "cargo": "2º SENADOR", "numero_candidato": "751" },
      { "cargo": "GOVERNADOR", "numero_candidato": "81" },
      { "cargo": "PRESIDENTE", "numero_candidato": "65" }
    ]
  }
  ```

### 3. Retrieve Live Election Tally
- **Endpoint:** `GET /backend/apuracao`
- **Response:** Total votes per candidate, blank votes, null votes, and calculated percentages.

### 4. Health Check / Status
- **Endpoint:** `GET /backend/status`
- **Response:** Operational API status, MySQL database connectivity, and server timestamp.

---

## 🧪 Test Suite & Simulators (`tests/`)

The repository includes a dedicated [`tests/`](tests/) folder containing terminal simulators, load testers, and automated API contract suites:

| File | Description |
| :--- | :--- |
| **[`tests/index.html`](tests/index.html)** | 🌐 **Visual Dashboard:** Browser GUI featuring an interactive virtual booth, configurable voter load tester, and live tallying view. |
| **[`tests/test_sistema_api.php`](tests/test_sistema_api.php)** | 🧪 **Contract Validator:** 12 automated test cases covering HTTP 200, 201, 400, 404, query filters, and zero-report validation (runs in PHP CLI or web browser). |
| **[`tests/simulador_poke.php`](tests/simulador_poke.php)** | 🤖 **Voting Terminal Simulator:** Emulates full web client voter journeys with latency tracking and audible beeps. |
| **[`tests/simulador_eleicao_massa.php`](tests/simulador_eleicao_massa.php)** | ⚡ **Load & Stress Tester:** Fires hundreds of concurrent votes using `curl_multi`, measuring RPS and latency profiles. |
| **[`tests/simulador_teclado_matricial.php`](tests/simulador_teclado_matricial.php)**| ⌨️ **Keypad Validator:** Validates business rules for digit masks per office, special keys, and software debounce. |
| **[`tests/run_tests.bat`](tests/run_tests.bat)** | 🚀 1-click interactive menu for Windows environments (invokes PHP CLI). |
| **[`tests/run_tests.sh`](tests/run_tests.sh)** | 🐧 Executable interactive menu for Linux / macOS environments (invokes PHP CLI). |

### Running Tests in Terminal:
```bash
# On Windows:
tests\run_tests.bat

# On Linux / macOS:
chmod +x tests/run_tests.sh
./tests/run_tests.sh
```

---

## 🐳 DevOps and Containers (Optional)

For modern containerized environments, the [`devops/`](devops/) folder supplies production-ready configurations:

- **Docker Compose:**
  ```bash
  docker compose -f devops/docker/docker-compose.yml up -d
  ```
  *Spins up Apache/PHP on port 8080 and MariaDB on port 3306.*
- **Podman:** Podman Compose support with `devops/podman/podman-compose.yml`.
- **Kubernetes:** Declarative manifests under `devops/kubernetes/` ready for K8s deployment.
- **GitHub Actions CI/CD:** Automated pipeline in `.github/workflows/docker-ci-cd.yml` with build verification and GHCR container publishing.

---

## 🌐 Live Online Demo

Experience the Pokémon Electronic Voting Machine in a live production environment:

👉 **[http://urna.gamer.free](http://urna.gamer.free)**

- 🗳️ **Voting Booth:** [http://urna.gamer.free](http://urna.gamer.free) *(or [http://urna.gamer.free/frontend/index.html](http://urna.gamer.free/frontend/index.html))*
- 📊 **Real-Time Results:** [http://urna.gamer.free/apuracao](http://urna.gamer.free/apuracao) *(or [http://urna.gamer.free/frontend/apuracao.html](http://urna.gamer.free/frontend/apuracao.html))*
- 🔌 **REST Voting API:** [http://urna.gamer.free/backend/votos](http://urna.gamer.free/backend/votos)

---

## 📄 License

This project is licensed under the **MIT License** for educational and entertainment purposes.  
Pokémon characters, names, and artwork are registered trademarks of **Nintendo / Creatures Inc. / GAME FREAK inc.**

---

<div align="center">
Crafted with ⚡ for Pokémon fans and election technology enthusiasts.
</div>
