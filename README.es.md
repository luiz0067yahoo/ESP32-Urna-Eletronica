# 🗳️ Urna Electrónica Pokémon • Elecciones 2026

<div align="center">

[![English](https://img.shields.io/badge/Language-English-blue?style=for-the-badge)](README.md)
[![Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green?style=for-the-badge)](README.pt.md)
[![Español](https://img.shields.io/badge/Idioma-Espa%C3%B1ol-yellow?style=for-the-badge)](README.es.md)
[![Italiano](https://img.shields.io/badge/Lingua-Italiano-red?style=for-the-badge)](README.it.md)

<br/>

![Estado del Proyecto](https://img.shields.io/badge/Estado-100%25%20Operativo-success?style=for-the-badge&logo=checkmarx)
![Arquitectura](https://img.shields.io/badge/Arquitectura-100%25%20Web-blue?style=for-the-badge&logo=html5)
![PHP](https://img.shields.io/badge/PHP-7.4%20%7C%208.x-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-5.7%20%7C%208.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-Vanilla%20ES6+-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Alojamiento](https://img.shields.io/badge/Deploy-cPanel%20%7C%20Hostinger%20%7C%20Apache-E65100?style=for-the-badge&logo=apache)

**Sistema completo de votación electrónica inspirado en el estándar oficial del Tribunal Superior Electoral (TSE) con temática Pokémon.**  
Desarrollado en arquitectura 100% Web (HTML5, CSS3, JavaScript Vanilla + API RESTful PHP + MySQL/MariaDB).

[🌐 Demostración Online en Vivo](http://urna.gamer.free) • [📖 Guía de Despliegue](#-despliegue-en-alojamiento-tradicional-cpanel--hostinger--locaweb) • [🧪 Batería de Pruebas](#-batera-de-pruebas-y-simuladores-tests) • [🔌 Documentación de la API](#-documentacin-de-la-api-restful)

</div>

---

## 📑 Tabla de Contenidos

- [Visión General](#-visin-general)
- [Capturas de Pantalla y Demostración](#-capturas-de-pantalla-y-demostracin)
- [Características Principales](#-caractersticas-principales)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Despliegue en Alojamiento Tradicional (cPanel / Hostinger / Locaweb)](#-despliegue-en-alojamiento-tradicional-cpanel--hostinger--locaweb)
- [Ejecución Local (XAMPP / WampServer / PHP CLI)](#-ejecucin-local)
- [Base de Datos y Población Oficial (100% PHP)](#-base-de-datos-y-poblacin-oficial-100-php)
- [Documentación de la API RESTful](#-documentacin-de-la-api-restful)
- [Batería de Pruebas y Simuladores (`tests/`)](#-batera-de-pruebas-y-simuladores-tests)
- [DevOps y Contenedores (Opcional)](#-devops-y-contenedores-opcional)
- [Licencia y Créditos](#-licencia)

---

## ⚡ Inicio Rápido (start.bat / start.sh)

El proyecto incluye un menú interactivo unificado en la raíz para iniciar cualquier entorno con 1 clic:

- **En Windows:** Haz doble clic en [`start.bat`](start.bat) (o ejecútalo en CMD/PowerShell).
- **En Linux / macOS:** Ejecuta en la terminal:
  ```bash
  chmod +x start.sh
  ./start.sh
  ```

El menú permite seleccionar dinámicamente:
```
 [1] 🐳 Docker Compose      (Inicia Apache + PHP + MariaDB + phpMyAdmin)
 [2] 🦭 Podman Compose      (Contenedores vía Podman)
 [3] ☸️ Kubernetes          (Despliegue de Manifiestos K8s / Ingress)
 [4] 🐘 PHP + MySQL Local   (Servidor Integrado de PHP / XAMPP)
 [5] 🛑 Detener Servicios   (Apaga Docker, Podman o PHP Local)
 [0] ❌ Salir
```

---

## 🔍 Visión General

La **Urna Electrónica Pokémon** reproduce con total fidelidad la experiencia de votación cívica oficial:
- **Cabina de Votación Digital:** Interfaz con teclado numérico de alta precisión, pantalla LCD digital, fotografías de candidatos, hoja electoral de consulta y efectos sonoros emblemáticos (bip de pulsación y melodía trisonora de FIN).
- **Panel de Escrutinio en Tiempo Real:** Diseño televisivo con barras verticales proporcionales, reloj digital dinámico, avance de secciones y fotos oficiales de candidatos.
- **Backend Robusto y Ligero:** API RESTful modular en PHP compatible con cualquier hosting compartido, sin dependencias de frameworks pesados y con soporte nativo de MySQL/MariaDB.

---

## 📸 Capturas de Pantalla y Demostración

### 1. Cabina de Votación (Urna Electrónica)
*Pantalla digital, botones interactivos `BLANCO`, `CORRIGE`, `CONFIRMA`, respuesta sonora mediante Web Audio API y flujo de los 6 cargos electivos.*

![Cabina de Votación](docs/urna_eletronica.png)

### 2. Escrutinio en Directo • Presidente de la República
*Gráficos verticales con ilustraciones de PokeAPI, cálculo de porcentajes en tiempo real y destaque visual de líderes electorales.*

![Escrutinio Presidente](docs/apuracao_presidente.png)

### 3. Escrutinio en Directo • Gobernador del Estado
*Navegación dinámica entre cargos electivos (Presidente, Gobernador, 1º y 2º Senador, Diputado Federal, Diputado Estatal).*

![Escrutinio Gobernador](docs/apuracao_governador.png)

---

## ✨ Características Principales

- 🗳️ **Flujo Electoral Oficial (6 Cargos Consecutivos):**
  1. Diputado Estatal *(5 dígitos)*
  2. Diputado Federal *(4 dígitos)*
  3. 1º Senador *(3 dígitos)*
  4. 2º Senador *(3 dígitos)*
  5. Gobernador *(2 dígitos)*
  6. Presidente de la República *(2 dígitos)*
- ⌨️ **Validador de Entrada por Software:** Control estricto de máscaras numéricas, tecla `BLANCO`, anulación con `CORRIGE` y registro con `CONFIRMA`.
- 🔊 **Efectos Sonoros Auténticos:** Audio sintetizado mediante Web Audio API que emula las pulsaciones y el acorde final oficial.
- �- 🔄 **Sincronización Periódica:** La pantalla de escrutinio consulta la base de datos cada 5 segundos sin recargar la página.

---

## 📁 Estructura del Repositorio

```text
ESP32-Urna-Eletronica/
│
├── start.bat                     # ⚡ Iniciador Central Windows (Docker, Podman, K8s, PHP Local)
├── start.sh                      # 🐧 Iniciador Central Linux/macOS
├── .env.example                  # 🔐 Plantilla centralizada de variables de entorno (Root, Backend, DevOps)
├── .htaccess                     # ⚙️ Reglas de Apache (Reescritura a frontend/ y seguridad)
├── README.md                     # 📖 Documentação oficial (Inglés)
├── README.pt.md                  # 📖 Documentación en Portugués
├── README.es.md                  # 📖 Documentación en Español
├── README.it.md                  # 📖 Documentación en Italiano
│
├── frontend/                     # 🌐 Aplicación Web del Cliente
│   ├── index.html                # Urna Electrónica (Cabina de Votación)
│   ├── apuracao.html             # Panel de Escrutinio en Tiempo Real
│   ├── urna.js                   # Script de compatibilidad de la cabina
│   ├── css/                      # Hojas de estilo temáticas y responsivas
│   │   ├── style.css             # Estilos globales y tipografía
│   │   ├── urna.css              # Gabinete de la urna, pantalla LCD y teclado
│   │   ├── apuracao.css          # Estilo marcador televisivo y barras verticales
│   │   └── santinhos.css         # Modal de consulta electoral de candidatos
│   └── js/                       # Lógica de votación y reglas electorales
│       ├── urna.js               # Controlador de la urna (máscara, audio y transmisión HTTP)
│       ├── apuracao.js           # Controlador de escrutinio (gráficos, polling y porcentajes)
│       ├── partidos.js           # Registro oficial de partidos políticos Pokémon
│       ├── candidatos/           # Registros modulares de candidatos por cargo
│       │   ├── candidato.js      # Modelo de datos de Candidato
│       │   ├── presidentes.js    # Candidatos a Presidente
│       │   ├── governadores.js   # Candidatos a Gobernador
│       │   ├── senadores_1.js    # Candidatos a 1º Senador
│       │   ├── senadores_2.js    # Candidatos a 2º Senador
│       │   ├── deputados_federais.js  # Candidatos a Diputado Federal
│       │   └── deputados_estaduais.js # Candidatos a Diputado Estatal
│       └── artes/                # Ilustraciones oficiales en alta resolución (PokeAPI)
│
├── backend/                      # ⚙️ API RESTful en PHP
│   ├── index.php                 # Enrutador central (/votos, /apuracao, /status)
│   ├── route.php                 # Motor de enrutamiento HTTP independiente y ligero
│   ├── conecta.php               # Gestor de conexión PDO a MySQL (lee config.php o .env)
│   ├── config.example.php        # Plantilla de configuración para hosting compartido
│   ├── .htaccess                 # Reescritura para URLs amigables
│   ├── votos/index.php           # Endpoint directo de votos (compatible sin mod_rewrite)
│   └── apuracao/index.php        # Endpoint directo de escrutinio (compatible sin mod_rewrite)crutinio (compatible sin mod_rewrite)       # Gestor de conexión PDO a MySQL (lee config.php o .env)
│   ├── config.example.php        # Plantilla de configuración para hosting compartido
│   ├── .env.example              # Plantilla de variables de entorno
│   ├── .htaccess                 # Reescritura para URLs amigables
│   ├── votos/index.php           # Endpoint directo de votos (compatible sin mod_rewrite)
│   └── apuracao/index.php        # Endpoint directo de escrutinio (compatible sin mod_rewrite)
│
├── db/                           # 🗄️ Base de Datos MySQL (100% PHP • Cero archivos .sql)
│   ├── install.php               # Instalador inteligente (ejecuta migraciones y seeds en PHP)
│   ├── migrate.php               # Ejecutor de migraciones (llama a db/migrate/index.php)
│   ├── seed.php                  # Ejecutor de seeds (llama a db/seed/index.php)
│   │
│   ├── migrate/                  # 🛠️ Migraciones Individuales por Tabla (100% PHP)
│   │   ├── partidos.php          # Script PHP creador de tabla 'partidos'
│   │   ├── candidatos.php        # Script PHP creador de tabla 'candidatos'
│   │   ├── votos.php             # Script PHP creador de tabla 'votos'
│   │   └── index.php             # Ejecutor de todas las migraciones
│   │
│   └── seed/                     # 🌱 Pobladores (Seeds) Individuales por Tabla (100% PHP)
│       ├── partidos.php          # Script PHP para insertar partidos
│       ├── candidatos.php        # Script PHP para insertar candidatos oficiales
│       ├── votos.php             # Script PHP con votos iniciales de demostración
│       └── index.php             # Ejecutor de todos los seeds
│
├── tests/                        # 🧪 Batería de Pruebas y Simuladores (100% PHP)
│   ├── index.html                # Panel visual en el navegador con simulador y pruebas de carga
│   ├── test_sistema_api.php      # Pruebas automatizadas de contrato API (PHP CLI / Web)
│   ├── simulador_poke.php        # Simulador de Terminal Electoral (cliente de votación PHP)
│   ├── simulador_eleicao_massa.php # Simulador de carga y concurrencia HTTP vía curl_multi
│   ├── simulador_teclado_matricial.php # Validador de reglas de dígitos y teclado por software
│   ├── run_tests.bat             # Menú interactivo de pruebas para Windows (PHP CLI)
│   ├── run_tests.sh              # Menú interactivo ejecutable para Linux / macOS (PHP CLI)
│   └── README.md                 # Documentación detallada de pruebas
│
├── devops/                       # 🐳 Contenedores e Infraestructura (Opcional)
│   ├── docker/                   # Dockerfile y docker-compose.yml (Apache + PHP 8.2 + MariaDB)
│   ├── podman/                   # Containerfile y podman-compose
│   └── kubernetes/               # Manifiestos de Deployment, Service e Ingress
│
└── docs/                         # 🖼️ Recursos visuales de la documentación
    ├── urna_eletronica.png
    ├── apuracao_presidente.png
    └── apuracao_governador.png
```

---

## 🌐 Despliegue en Alojamiento Tradicional (cPanel / Hostinger / Locaweb)

El proyecto está diseñado para funcionar en **cualquier proveedor de hosting compartido** con **HTML, CSS, JS, PHP (7.4 u 8.x) y MySQL / MariaDB**.

### Paso 1: Subir los Archivos
1. Comprime los archivos en un `.zip` o conéctate mediante **FTP (FileZilla)**.
2. Extrae todos los archivos en la raíz pública de tu hosting (habitualmente **`public_html`** o **`www`**).

### Paso 2: Crear la Base de Datos en el Panel de Control
1. En el panel (cPanel, hPanel, etc.), abre la sección **Bases de Datos MySQL**.
2. Crea una nueva base de datos (ej: `usuario_urna`).
3. Crea un usuario MySQL con contraseña segura y asígnalo a la base de datos con **Todos los Privilegios** (*ALL PRIVILEGES*).

### Paso 3: Configurar las Credenciales
Dentro de la carpeta `backend/`, crea un archivo llamado **`config.php`** (puedes copiar [`backend/config.example.php`](backend/config.example.php)):

```php
<?php
// Configuración de Base de Datos MySQL
define('DB_HOST', 'localhost');          // Generalmente 'localhost' en hosting compartido
define('DB_NAME', 'nombre_de_tu_base');  // Nombre de la base creada en cPanel
define('DB_USER', 'nombre_de_tu_usuario'); // Usuario creado en cPanel
define('DB_PASS', 'tu_contraseña_secreta'); // Contraseña del usuario
define('DB_PORT', '3306');
```
*(Si tu hosting admite `.env`, también puedes configurar `backend/.env`)*.

### Paso 4: Crear Tablas y Candidatos (100% PHP)
No es necesario importar ningún archivo SQL. La creación y el llenado de datos se realizan completamente mediante scripts PHP:
- **Desde el Navegador (Más Fácil):**
  Abre en tu navegador:
  `https://tudominio.com/db/install.php`
- **Desde la Terminal / SSH:**
  ```bash
  php db/install.php
  ```

### Paso 5: Acceder a la Aplicación
- 🗳️ **Cabina de Votación:** `https://tudominio.com/` *(enrutado por `.htaccess` hacia `/frontend/index.html`)*
- 📊 **Escrutinio en Directo:** `https://tudominio.com/apuracao` *(o `/frontend/apuracao.html`)*
- 🔌 **API REST de Votación:** `https://tudominio.com/backend/votos`

---

## 💻 Ejecución Local

### Requisitos Previos:
- Servidor local como **XAMPP**, **WampServer**, **Laragon** o **PHP nativo (CLI)**.
- MySQL o MariaDB activo en el puerto 3306.

### Paso a Paso:
1. Clona el repositorio dentro de tu directorio web local (ej: `htdocs` en XAMPP o `www` en Wamp):
   ```bash
   git clone https://github.com/luiz0067yahoo/ESP32-Urna-Eletronica.git
   ```
2. Crea la base de datos `urna` en MySQL:
   ```sql
   CREATE DATABASE urna CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Configura `backend/config.php` o `backend/.env` con tus credenciales locales (`root` sin contraseña por defecto).
4. Ejecuta el instalador automático:
   ```bash
   php db/install.php
   ```
5. Accede en el navegador:
   - Cabina de Votación: `http://localhost/ESP32-Urna-Eletronica/`
   - Escrutinio: `http://localhost/ESP32-Urna-Eletronica/apuracao` *(o `frontend/apuracao.html`)*

*(O ejecuta con el servidor integrado de PHP mediante la opción [4] de `start.bat` / `start.sh`).*

---

## 🗄️ Base de Datos y Población Oficial (100% PHP)

La base de datos consta de tres tablas relacionales optimizadas con índices:

### 1. `partidos`
Contiene las formaciones políticas temáticas de Pokémon:
| Sigla | Nombre del Partido | Lema |
| :--- | :--- | :--- |
| **POKPELE** | Partido Organizado Karvalho Profesor Eléctrico | Energía e innovación para todos |
| **POKPFGO** | Partido Organizado Karvalho Profesor Fuego | Llama de transformación |
| **POKPAGU** | Partido Organizado Karvalho Profesor Agua | El agua es vida y conservación |
| **POKPPSI** | Partido Organizado Karvalho Profesor Psíquico | Conocimiento, ciencia y sabiduría |
| *...* | *Demás formaciones temáticas* | *...* |

### 2. `candidatos`
Registra los candidatos oficiales por cargo:
- **Presidente:** Pikachu (65), Squirtle (63), Charmander (62).
- **Gobernador:** Manectric (81), Zapdos (82), Magmortar (84), Blaziken (85), Feraligatr (87), Greninja (88), etc.
- **Senador:** Alakazam (701), Gengar (702), Dragonite (703), Mewtwo (751), Lugia (752), Ho-Oh (753).
- **Diputado Federal:** Raichu (9101), Jolteon (9102), Charizard (9201), Blastoise (9301).
- **Diputado Estatal:** Pichu (90101), Mareep (90102), Cyndaquil (90201), Totodile (90301).

### 3. `votos`
Almacena individualmente cada voto emitido con marca temporal e identificador del cargo.

---

### 📂 Ejecución Modular de Migraciones y Seeds (100% PHP)

Construido con una arquitectura modular sin archivos `.sql`:

#### A) Migraciones Individuales (`db/migrate/`)
Crea la estructura de tablas vía PHP:
- **Partidos:** `php db/migrate/partidos.php`
- **Candidatos:** `php db/migrate/candidatos.php`
- **Votos:** `php db/migrate/votos.php`
- **Todas las Migraciones juntas:** `php db/migrate/index.php` *(o `php db/migrate.php`)*

#### B) Seeds Individuales (`db/seed/`)
Puebla los datos iniciales vía PHP:
- **Partidos:** `php db/seed/partidos.php`
- **Candidatos:** `php db/seed/candidatos.php`
- **Votos:** `php db/seed/votos.php`
- **Todos los Seeds juntos:** `php db/seed/index.php` *(o `php db/seed.php`)*

#### C) Instalador Inteligente Completo
- **Instalador Unificado:** `php db/install.php` (o visita `https://tudominio.com/db/install.php` en el navegador para verificar, migrar y poblar en un solo paso).

---

## 🔌 Documentación de la API RESTful

Todas las respuestas se emiten en formato `JSON` con codificación `UTF-8`.

### 1. Registrar Voto Individual
- **Ruta:** `POST /backend/votos`
- **Cabeceras:** `Content-Type: application/json`
- **Cuerpo (Payload):**
  ```json
  {
    "cargo": "PRESIDENTE",
    "numero_candidato": "65"
  }
  ```
- **Respuesta (HTTP 201):**
  ```json
  {
    "status": "success",
    "message": "Voto para PRESIDENTE computado com sucesso!",
    "id": 142
  }
  ```

### 2. Registrar Votación Completa en Lote
- **Ruta:** `POST /backend/votos`
- **Cuerpo (Payload):**
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

### 3. Consultar Escrutinio General
- **Ruta:** `GET /backend/apuracao`
- **Respuesta:** Total de votos por candidato, votos en blanco, nulos y porcentaje calculado.

### 4. Consultar Estado del Sistema
- **Ruta:** `GET /backend/status`
- **Respuesta:** Estado del servicio API, conexión con MySQL y marca de tiempo del servidor.

---

## 🧪 Batería de Pruebas y Simuladores (`tests/`)

El repositorio incluye la carpeta dedicada [`tests/`](tests/) con simuladores, pruebas de carga y validadores de contrato:

| Archivo | Descripción |
| :--- | :--- |
| **[`tests/index.html`](tests/index.html)** | 🌐 **Panel Visual:** Interfaz web en el navegador con terminal virtual, pruebas de carga y escrutinio en directo. |
| **[`tests/test_sistema_api.php`](tests/test_sistema_api.php)** | 🧪 **Validador de Contratos:** 12 casos de prueba automatizados cubriendo HTTP 200, 201, 400, 404, filtros y zerésima (ejecutable en PHP CLI o navegador). |
| **[`tests/simulador_poke.php`](tests/simulador_poke.php)** | 🤖 **Simulador del Terminal:** Emula el flujo completo de votación con medición de latencias y sonidos. |
| **[`tests/simulador_eleicao_massa.php`](tests/simulador_eleicao_massa.php)** | ⚡ **Pruebas de Carga y Estrés:** Emite cientos de votos en paralelo mediante `curl_multi` con cálculo de RPS y percentiles. |
| **[`tests/simulador_teclado_matricial.php`](tests/simulador_teclado_matricial.php)**| ⌨️ **Validador de Teclado:** Valida las reglas de conteo de dígitos por cargo, teclas especiales y antirrebote (debounce). |
| **[`tests/run_tests.bat`](tests/run_tests.bat)** | 🚀 Menú interactivo en 1 clic para entorno Windows (invoca PHP CLI). |
| **[`tests/run_tests.sh`](tests/run_tests.sh)** | 🐧 Menú interactivo ejecutable para Linux / macOS (invoca PHP CLI). |

### Cómo Ejecutar las Pruebas en Terminal:
```bash
# En Windows:
tests\run_tests.bat

# En Linux / macOS:
chmod +x tests/run_tests.sh
./tests/run_tests.sh
```

---

## 🐳 DevOps y Contenedores (Opcional)

Para despliegues basados en contenedores, la carpeta [`devops/`](devops/) incluye arquitecturas listas para producción:

- **Docker Compose:**
  ```bash
  docker compose -f devops/docker/docker-compose.yml up -d
  ```
  *Inicia Apache/PHP en el puerto 8080 y MariaDB en el puerto 3306.*
- **Podman:** Compatibilidad con Podman Compose mediante `devops/podman/podman-compose.yml`.
- **Kubernetes:** Manifiestos listos en `devops/kubernetes/` para despliegues en clúster K8s.
- **GitHub Actions CI/CD:** Flujo de integración continua en `.github/workflows/docker-ci-cd.yml` con publicación de imágenes en GHCR.

---

## 🌐 Demostración Online en Vivo

Prueba la Urna Electrónica Pokémon directamente en el entorno de producción:

👉 **[http://urna.gamer.free](http://urna.gamer.free)**

- 🗳️ **Cabina de Votación:** [http://urna.gamer.free](http://urna.gamer.free) *(o [http://urna.gamer.free/frontend/index.html](http://urna.gamer.free/frontend/index.html))*
- 📊 **Escrutinio en Tiempo Real:** [http://urna.gamer.free/apuracao](http://urna.gamer.free/apuracao) *(o [http://urna.gamer.free/frontend/apuracao.html](http://urna.gamer.free/frontend/apuracao.html))*
- 🔌 **API REST de Votos:** [http://urna.gamer.free/backend/votos](http://urna.gamer.free/backend/votos)

---

## 📄 Licencia

Este proyecto se publica bajo la **Licencia MIT** para fines educativos y de entretenimiento.  
Los personajes, nombres y elementos artísticos de Pokémon son marcas registradas de **Nintendo / Creatures Inc. / GAME FREAK inc.**

---

<div align="center">
Desarrollado con ⚡ para los fanáticos de Pokémon y apasionados de los sistemas electorales.
</div>
