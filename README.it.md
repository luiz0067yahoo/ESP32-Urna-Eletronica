# 🗳️ Urna Elettronica Pokémon • Elezioni 2026

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

<br/>

![Stato del Progetto](https://img.shields.io/badge/Stato-100%25%20Operativo-success?style=for-the-badge&logo=checkmarx)
![Architettura](https://img.shields.io/badge/Architettura-100%25%20Web-blue?style=for-the-badge&logo=html5)
![PHP](https://img.shields.io/badge/PHP-7.4%20%7C%208.x-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-5.7%20%7C%208.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Vanilla%20ES6+-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Hosting](https://img.shields.io/badge/Deploy-cPanel%20%7C%20Hostinger%20%7C%20Apache-E65100?style=for-the-badge&logo=apache)

**Sistema completo di voto elettronico ispirato agli standard ufficiali del Tribunale Superiore Elettorale (TSE) brasiliano a tema Pokémon.**  
Sviluppato con architettura 100% Web (HTML5, CSS3, JavaScript Vanilla + API RESTful PHP + MySQL/MariaDB).

[🌐 Prova la Demo Online](http://urna.gamer.free) • [📖 Guida all'Hosting](#-distribuzione-su-hosting-tradizionale-cpanel--hostinger--locaweb) • [🧪 Suite di Test](#-suite-di-test--simulatori-tests) • [🔌 Documentazione API](#-documentazione-api-restful)

</div>

---

## 📑 Indice

- [Panoramica Generale](#-panoramica-generale)
- [Anteprima e Schermate del Sistema](#-anteprima-e-schermate-del-sistema)
- [Funzionalità Principali](#-funzionalit-principali)
- [Struttura del Repository](#-struttura-del-repository)
- [Distribuzione su Hosting Tradizionale (cPanel / Hostinger / Locaweb)](#-distribuzione-su-hosting-tradizionale-cpanel--hostinger--locaweb)
- [Esecuzione Locale (XAMPP / WampServer / PHP CLI)](#-esecuzione-locale)
- [Database & Popolamento Dati Ufficiale (100% PHP)](#-database--popolamento-dati-ufficiale-100-php)
- [Documentazione API RESTful](#-documentazione-api-restful)
- [Suite di Test & Simulatori (`tests/`)](#-suite-di-test--simulatori-tests)
- [DevOps e Container (Opzionale)](#-devops-e-container-opzionale)
- [Licenza e Riconoscimenti](#-licenza)

---

## ⚡ Avvio Rapido (start.bat / start.sh)

Il progetto include un menu interattivo unificato nella directory radice per avviare qualsiasi ambiente con 1 clic:

- **Su Windows:** Fai doppio clic su [`start.bat`](start.bat) (o eseguilo dal prompt CMD/PowerShell).
- **Su Linux / macOS:** Esegui nel terminale:
  ```bash
  chmod +x start.sh
  ./start.sh
  ```

Il menu consente di selezionare:
```
 [1] 🐳 Docker Compose      (Avvia Apache + PHP + MariaDB + phpMyAdmin)
 [2] 🦭 Podman Compose      (Container tramite Podman)
 [3] ☸️ Kubernetes          (Distribuzione Manifesti K8s / Ingress)
 [4] 🐘 PHP + MySQL Locale  (Server Integrato PHP / XAMPP)
 [5] 🛑 Ferma Servizi       (Arresta Docker, Podman o PHP Locale)
 [0] ❌ Esci
```

---

## 🔍 Panoramica Generale

L'**Urna Elettronica Pokémon** ricrea con precisione millimetrica l'esperienza di voto ufficiale:
- **Cabina Elettorale Digitale:** Interfaccia con tastierino numerico ad alta reattività, schermo LCD digitale, foto ufficiali dei candidati, promemoria elettorale e feedback sonori autentici (bip dei tasti e tono conclusivo ufficiale).
- **Tabellone di Scrutinio in Tempo Reale:** Layout televisivo con barre verticali proporzionali, orologio digitale sincronizzato, progressione dei seggi e ritratti dei candidati.
- **Backend Leggero e Robusto:** API RESTful modulare in PHP compatibile con qualsiasi hosting condiviso, senza dipendenze da framework pesanti e con supporto nativo a MySQL/MariaDB.

---

## 📸 Anteprima e Schermate del Sistema

### 1. Cabina Elettorale (Urna Elettronica)
*Schermo digitale, pulsanti interattivi `BRANCO` (Scheda bianca), `CORRIGE` (Correggi), `CONFIRMA` (Conferma), feedback audio sintetizzato via Web Audio API e percorso elettorale completo sui 6 incarichi.*

![Cabina Elettorale](docs/urna_eletronica.png)

### 2. Scrutinio dal Vivo • Presidente della Repubblica
*Grafici verticali con illustrazioni ufficiali PokeAPI, calcolo percentuale in tempo reale ed evidenziazione dei candidati in testa.*

![Scrutinio Presidente](docs/apuracao_presidente.png)

### 3. Scrutinio dal Vivo • Governatore dello Stato
*Navigazione dinamica tra le cariche elettorali (Presidente, Governatore, 1º e 2º Senatore, Deputato Federale, Deputato Statale).*

![Scrutinio Governatore](docs/apuracao_governador.png)

---

## ✨ Funzionalità Principali

- 🗳️ **Percorso Elettorale Ufficiale (6 Cariche in Sequenza):**
  1. Deputato Statale *(5 cifre)*
  2. Deputato Federale *(4 cifre)*
  3. 1º Senatore *(3 cifre)*
  4. 2º Senatore *(3 cifre)*
  5. Governatore *(2 cifre)*
  6. Presidente della Repubblica *(2 cifre)*
- ⌨️ **Validatore di Input Software:** Gestione rigorosa del formato cifre, tasto `BRANCO`, annullamento con `CORRIGE` e registrazione con `CONFIRMA`.
- 🔊 **Effetti Sonori Fedeli:** Audio sintetizzato tramite Web Audio API che riproduce fedelmente i toni di digitazione e l'accordo di chiusura dell'urna.
- 📡 **Invio Resiliente dei Voti:** Trasmissione automatica via richieste HTTP `POST` all'API, con memorizzazione locale di riserva in caso di disconnessione.
- 🔄 **Polling Dinamico dello Scrutinio:** Il tabellone elettorale interroga il database ogni 5 secondi aggiornando i dati senza ricaricare la pagina.

---

## 📁 Struttura del Repository

```text
ESP32-Urna-Eletronica/
│
├── start.bat                     # ⚡ Avviatore Windows (Docker, Podman, K8s, PHP Locale)
├── start.sh                      # 🐧 Avviatore Linux/macOS
├── .htaccess                     # ⚙️ Regole Apache (Reindirizzamento verso frontend/ e sicurezza)
├── README.md                     # 📖 Documentazione ufficiale (Inglese)
├── README.pt.md                  # 📖 Documentazione in Portoghese
├── README.es.md                  # 📖 Documentazione in Spagnolo
├── README.it.md                  # 📖 Documentazione in Italiano
│
├── frontend/                     # 🌐 Applicazione Web del Client
│   ├── index.html                # Urna Elettronica (Cabina di Voto)
│   ├── apuracao.html             # Tabellone di Scrutinio Elettorale in Tempo Reale
│   ├── urna.js                   # Script di compatibilità della cabina
│   ├── css/                      # Fogli di stile reattivi e tematici
│   │   ├── style.css             # Tipografia globale e layout di base
│   │   ├── urna.css              # Cabinet dell'urna, schermo LCD e tastierino
│   │   ├── apuracao.css          # Grafica televisiva, barre verticali e orologio
│   │   └── santinhos.css         # Finestra modale con il promemoria dei candidati
│   └── js/                       # Logica di controllo e regole elettorali
│       ├── urna.js               # Controller dell'urna (maschere numeriche, audio, invio HTTP)
│       ├── apuracao.js           # Controller dello scrutinio (polling, grafici e percentuali)
│       ├── partidos.js           # Registro ufficiale dei partiti politici Pokémon
│       ├── candidatos/           # Registri modulari dei candidati suddivisi per carica
│       │   ├── candidato.js      # Modello dati Candidato
│       │   ├── presidentes.js    # Candidati a Presidente
│       │   ├── governadores.js   # Candidati a Governatore
│       │   ├── senadores_1.js    # Candidati a 1º Senatore
│       │   ├── senadores_2.js    # Candidati a 2º Senatore
│       │   ├── deputados_federais.js  # Candidati a Deputato Federale
│       │   └── deputados_estaduais.js # Candidati a Deputato Statale
│       └── artes/                # Ritratti ufficiali PokeAPI ad alta definizione
│
├── backend/                      # ⚙️ API RESTful in PHP
│   ├── index.php                 # Router centrale (/votos, /apuracao, /status)
│   ├── route.php                 # Motore di instradamento HTTP leggero e autonomo
│   ├── conecta.php               # Gestore connessione PDO a MySQL (legge config.php o .env)
│   ├── config.example.php        # Modello di configurazione per hosting condiviso
│   ├── .env.example              # Modello per variabili d'ambiente
│   ├── .htaccess                 # Riscrizione URL puliti
│   ├── votos/index.php           # Endpoint diretto per voti (compatibile senza mod_rewrite)
│   └── apuracao/index.php        # Endpoint diretto per lo scrutinio (compatibile senza mod_rewrite)
│
├── db/                           # 🗄️ Database MySQL (100% PHP • Zero file .sql)
│   ├── install.php               # Installer intelligente (esegue migrazioni e seed via PHP)
│   ├── migrate.php               # Esecutore migrazioni (richiama db/migrate/index.php)
│   ├── seed.php                  # Esecutore seed (richiama db/seed/index.php)
│   │
│   ├── migrate/                  # 🛠️ Migrazioni Singole per Tabella (100% PHP)
│   │   ├── partidos.php          # Script PHP per la tabella 'partidos'
│   │   ├── candidatos.php        # Script PHP per la tabella 'candidatos'
│   │   ├── votos.php             # Script PHP per la tabella 'votos'
│   │   └── index.php             # Esecutore di tutte le migrazioni
│   │
│   └── seed/                     # 🌱 Popolamento (Seed) Singolo per Tabella (100% PHP)
│       ├── partidos.php          # Script PHP per registrare i partiti
│       ├── candidatos.php        # Script PHP per registrare i candidati ufficiali
│       ├── votos.php             # Script PHP con voti iniziali dimostrativi
│       └── index.php             # Esecutore di tutti i seed
│
├── tests/                        # 🧪 Suite di Test, Simulatori e Collaudo (100% PHP)
│   ├── index.html                # Cruscotto visivo su browser con simulatore e test di carico
│   ├── test_sistema_api.php      # Suite automatizzata di test contrattuali API (PHP CLI / Web)
│   ├── simulador_poke.php        # Simulatore del Terminale Elettorale (client di voto PHP)
│   ├── simulador_eleicao_massa.php # Simulatore di carico ad alta concorrenza via curl_multi
│   ├── simulador_teclado_matricial.php # Validatore di regole numeriche e antirimbalzo software
│   ├── run_tests.bat             # Menu interativo in 1 clic per Windows (PHP CLI)
│   ├── run_tests.sh              # Script eseguibile per Linux / macOS (PHP CLI)
│   └── README.md                 # Documentazione approfondita dei test
│
├── devops/                       # 🐳 Container e Infrastruttura (Opzionale)
│   ├── docker/                   # Dockerfile e docker-compose.yml (Apache + PHP 8.2 + MariaDB)
│   ├── podman/                   # Containerfile e podman-compose
│   └── kubernetes/               # Manifesti di Deployment, Service e Ingress
│
└── docs/                         # 🖼️ Risorse grafiche della documentazione
    ├── urna_eletronica.png
    ├── apuracao_presidente.png
    └── apuracao_governador.png
```

---

## 🌐 Distribuzione su Hosting Tradizionale (cPanel / Hostinger / Locaweb)

Il progetto è progettato per essere installato su **qualsiasi provider di hosting web condiviso** che supporti **HTML, CSS, JS, PHP (7.4 o 8.x) e MySQL / MariaDB**.

### Passo 1: Caricare i File
1. Comprimi i file del progetto in formato `.zip` oppure connettiti via **FTP (FileZilla)**.
2. Estrai tutti i file direttamente nella directory pubblica radice (di norma **`public_html`** o **`www`**).

### Passo 2: Creare il Database nel Pannello di Controllo
1. Nel pannello (cPanel, hPanel, ecc.), apri la sezione **Database MySQL**.
2. Crea un nuovo database (es: `utente_urna`).
3. Crea un nuovo utente MySQL con password robusta e assegnalo al database con **Tutti i Privilegi** (*ALL PRIVILEGES*).

### Passo 3: Configurare le Credenziali di Accesso
All'interno della cartella `backend/`, crea un file denominato **`config.php`** (puoi copiare [`backend/config.example.php`](backend/config.example.php)):

```php
<?php
// Configurazione del Database MySQL
define('DB_HOST', 'localhost');          // Generalmente 'localhost' sulla maggior parte degli hosting
define('DB_NAME', 'nome_del_tuo_db');    // Nome del database creato nel cPanel
define('DB_USER', 'nome_del_tuo_utente'); // Utente creato nel cPanel
define('DB_PASS', 'tua_password_segreta'); // Password associata all'utente
define('DB_PORT', '3306');
```
*(Se il tuo hosting supporta i file `.env`, puoi in alternativa configurare `backend/.env`)*.

### Passo 4: Creare Tabelle e Candidati (100% PHP)
Non è necessario importare alcun file SQL. La creazione delle strutture e l'inserimento dei dati avvengono interamente tramite script PHP:
- **Dal Browser (Metodo consigliato):**
  Apri nel browser l'indirizzo:
  `https://tuodominio.it/db/install.php`
- **Dal Terminale / SSH:**
  ```bash
  php db/install.php
  ```

### Passo 5: Accedere all'Applicazione
- 🗳️ **Cabina Elettorale:** `https://tuodominio.it/` *(instradato tramite `.htaccess` a `/frontend/index.html`)*
- 📊 **Scrutinio dal Vivo:** `https://tuodominio.it/apuracao` *(o `/frontend/apuracao.html`)*
- 🔌 **API REST dei Voti:** `https://tuodominio.it/backend/votos`

---

## 💻 Esecuzione Locale

### Prerequisiti:
- Server locale come **XAMPP**, **WampServer**, **Laragon** o **PHP nativo (CLI)**.
- MySQL o MariaDB attivo sulla porta 3306.

### Procedura:
1. Clona il repository all'interno della cartella web locale (es: `htdocs` in XAMPP o `www` in Wamp):
   ```bash
   git clone https://github.com/luiz0067yahoo/ESP32-Urna-Eletronica.git
   ```
2. Crea il database `urna` nel tuo MySQL:
   ```sql
   CREATE DATABASE urna CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Configura `backend/config.php` o `backend/.env` con le tue credenziali locali (`root` senza password di default).
4. Avvia l'installer automatico:
   ```bash
   php db/install.php
   ```
5. Apri nel browser:
   - Cabina di Voto: `http://localhost/ESP32-Urna-Eletronica/`
   - Scrutinio: `http://localhost/ESP32-Urna-Eletronica/apuracao` *(o `frontend/apuracao.html`)*

*(In alternativa, usa il server integrato PHP avviando `start.bat` o `start.sh` con l'opzione [4]).*

---

## 🗄️ Database & Popolamento Dati Ufficiale (100% PHP)

Il database è strutturato su tre tabelle relazionali ottimizzate con indici:

### 1. `partidos`
Contiene le formazioni politiche a tema Pokémon:
| Sigla | Nome del Partito | Slogan |
| :--- | :--- | :--- |
| **POKPELE** | Partido Organizado Karvalho Professor Elétrico | Energia e innovazione per tutti |
| **POKPFGO** | Partido Organizado Karvalho Professor Fogo | Fiamma del cambiamento |
| **POKPAGU** | Partido Organizado Karvalho Professor Água | L'acqua è vita e tutela |
| **POKPPSI** | Partido Organizado Karvalho Professor Psíquico | Conoscenza, scienza e saggezza |
| *...* | *Altre formazioni a tema* | *...* |

### 2. `candidatos`
Registra tutti i candidati ufficiali per incarico:
- **Presidente:** Pikachu (65), Squirtle (63), Charmander (62).
- **Governatore:** Manectric (81), Zapdos (82), Magmortar (84), Blaziken (85), Feraligatr (87), Greninja (88), ecc.
- **Senatore:** Alakazam (701), Gengar (702), Dragonite (703), Mewtwo (751), Lugia (752), Ho-Oh (753).
- **Deputato Federale:** Raichu (9101), Jolteon (9102), Charizard (9201), Blastoise (9301).
- **Deputato Statale:** Pichu (90101), Mareep (90102), Cyndaquil (90201), Totodile (90301).

### 3. `votos`
Memorizza singolarmente ogni voto ricevuto con orario e codice della carica.

---

### 📂 Esecuzione Modulare di Migrazioni e Seed (100% PHP)

Architettura completamente modulare basata su **script puramente in PHP** (senza file `.sql`):

#### A) Migrazioni Singole (`db/migrate/`)
Creano la struttura delle tabelle via PHP:
- **Partiti:** `php db/migrate/partidos.php`
- **Candidati:** `php db/migrate/candidatos.php`
- **Voti:** `php db/migrate/votos.php`
- **Tutte le Migrazioni insieme:** `php db/migrate/index.php` *(o `php db/migrate.php`)*

#### B) Seed Singoli (`db/seed/`)
Popolano i dati iniziali via PHP:
- **Partiti:** `php db/seed/partidos.php`
- **Candidati:** `php db/seed/candidatos.php`
- **Voti:** `php db/seed/votos.php`
- **Tutti i Seed insieme:** `php db/seed/index.php` *(o `php db/seed.php`)*

#### C) Installer Intelligente Completo
- **Installer Unificato:** `php db/install.php` (oppure visita `https://tuodominio.it/db/install.php` nel browser per verificare, migrare e popolare in un unico passaggio).

---

## 🔌 Documentazione API RESTful

Tutte le risposte sono restituite in formato `JSON` codificato in `UTF-8`.

### 1. Registrare Singolo Voto
- **Endpoint:** `POST /backend/votos`
- **Header:** `Content-Type: application/json`
- **Payload:**
  ```json
  {
    "cargo": "PRESIDENTE",
    "numero_candidato": "65"
  }
  ```
- **Risposta (HTTP 201):**
  ```json
  {
    "status": "success",
    "message": "Voto para PRESIDENTE computado com sucesso!",
    "id": 142
  }
  ```

### 2. Registrare Sessione Completa in Batch
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

### 3. Consultare lo Scrutinio Generale
- **Endpoint:** `GET /backend/apuracao`
- **Risposta:** Totale voti per candidato, schede bianche, schede nulle e percentuali calcolate.

### 4. Consultare lo Stato del Sistema
- **Endpoint:** `GET /backend/status`
- **Risposta:** Stato operativo dell'API, stato della connessione MySQL e timestamp del server.

---

## 🧪 Suite di Test & Simulatori (`tests/`)

Il repository include la cartella [`tests/`](tests/) con simulatori di terminale, test di carico e suite automatizzate:

| File | Descrizione |
| :--- | :--- |
| **[`tests/index.html`](tests/index.html)** | 🌐 **Cruscotto Visivo:** Interfaccia grafica nel browser con cabina virtuale, test di carico parametrizzabile e scrutinio dal vivo. |
| **[`tests/test_sistema_api.php`](tests/test_sistema_api.php)** | 🧪 **Validatore di Contratti:** 12 casi di test automatizzati per HTTP 200, 201, 400, 404, filtri e zerésima (eseguibile via PHP CLI o browser). |
| **[`tests/simulador_poke.php`](tests/simulador_poke.php)** | 🤖 **Simulatore del Terminale:** Emula il client web eseguendo sessioni di voto con calcolo di latenza e audio. |
| **[`tests/simulador_eleicao_massa.php`](tests/simulador_eleicao_massa.php)** | ⚡ **Test di Carico & Stress:** Invia centinaia di voti simultanei tramite `curl_multi`, calcolando RPS e latenze. |
| **[`tests/simulador_teclado_matricial.php`](tests/simulador_teclado_matricial.php)**| ⌨️ **Validatore del Tastierino:** Verifica le regole sulle cifre per carica, i tasti speciali e l'antirimbalzo (debounce). |
| **[`tests/run_tests.bat`](tests/run_tests.bat)** | 🚀 Menu interattivo in 1 clic per Windows (invoca PHP CLI). |
| **[`tests/run_tests.sh`](tests/run_tests.sh)** | 🐧 Menu interattivo eseguibile per Linux / macOS (invoca PHP CLI). |

### Come Eseguire i Test nel Terminale:
```bash
# Su Windows:
tests\run_tests.bat

# Su Linux / macOS:
chmod +x tests/run_tests.sh
./tests/run_tests.sh
```

---

## 🐳 DevOps e Container (Opzionale)

Per ambienti containerizzati, la cartella [`devops/`](devops/) fornisce configurazioni pronte all'uso:

- **Docker Compose:**
  ```bash
  docker compose -f devops/docker/docker-compose.yml up -d
  ```
  *Avvia automaticamente Apache/PHP sulla porta 8080 e MariaDB sulla porta 3306.*
- **Podman:** Supporto a Podman Compose tramite `devops/podman/podman-compose.yml`.
- **Kubernetes:** Manifesti pronti in `devops/kubernetes/` per distribuzioni su cluster K8s.
- **GitHub Actions CI/CD:** Pipeline automatizzata in `.github/workflows/docker-ci-cd.yml` con validazione di build e pubblicazione su GHCR.

---

## 🌐 Prova la Demo Online

Accedi e collauda l'Urna Elettronica Pokémon direttamente nell'ambiente di produzione:

👉 **[http://urna.gamer.free](http://urna.gamer.free)**

- 🗳️ **Cabina Elettorale:** [http://urna.gamer.free](http://urna.gamer.free) *(o [http://urna.gamer.free/frontend/index.html](http://urna.gamer.free/frontend/index.html))*
- 📊 **Scrutinio in Tempo Reale:** [http://urna.gamer.free/apuracao](http://urna.gamer.free/apuracao) *(o [http://urna.gamer.free/frontend/apuracao.html](http://urna.gamer.free/frontend/apuracao.html))*
- 🔌 **API REST dei Voti:** [http://urna.gamer.free/backend/votos](http://urna.gamer.free/backend/votos)

---

## 📄 Licenza

Questo progetto è rilasciato sotto licenza **MIT** per scopi didattici e di intrattenimento.  
Personaggi, nomi e illustrazioni di Pokémon sono marchi registrati di **Nintendo / Creatures Inc. / GAME FREAK inc.**

---

<div align="center">
Realizzato con ⚡ per i fan di Pokémon e gli appassionati di tecnologie elettorali.
</div>
