# 🧪 Testes de Sistema & Simuladores (100% PHP) • Urna Eletrônica Pokémon

Esta pasta contém o ecossistema completo de **testes de sistema**, **simuladores do terminal eleitoral**, **testes de estresse/carga** e um **dashboard visual interativo** para a Urna Eletrônica Pokémon — desenvolvidos **100% em PHP**.

---

## 📁 Arquivos da Pasta `tests/`

| Arquivo | Descrição |
| :--- | :--- |
| **`index.html`** | 🌐 **Dashboard Visual Interativo:** Painel no navegador com terminal eleitoral interativo, sons do TSE (Web Audio API), teste de carga com barra de progresso e apuração em tempo real. |
| **`test_sistema_api.php`** | 🧪 **Suíte Automatizada de Testes de Sistema (PHP):** Validação de 12 casos de teste de contratos da API RESTful (HTTP 200, 201, 400, 404, Zerésima eleitoral e re-seed). |
| **`simulador_poke.php`** | 🤖 **Simulador do Terminal Eleitoral (PHP):** Emula o cliente web da Urna Eletrônica transmitindo votos via HTTP POST para a API REST, com medição de latência e sons de confirmação. |
| **`simulador_eleicao_massa.php`** | ⚡ **Simulador de Eleição em Massa / Teste de Carga (PHP):** Dispara requisições assíncronas concorrentes via `curl_multi` calculando RPS, latência e taxa de sucesso. |
| **`simulador_teclado_matricial.php`**| ⌨️ **Simulador de Teclado Virtual & Validador de Votos (PHP):** Emula as regras de contagem de dígitos por cargo, debounce de software e teclas de ação (BRANCO, CORRIGE, CONFIRMA). |
| **`run_tests.bat`** | 🚀 **Menu Interativo (Windows):** Permite escolher e rodar qualquer teste em 1 clique via PHP. |
| **`run_tests.sh`** | 🐧 **Menu Interativo (Linux/macOS):** Script executável para rodar a suíte no terminal via PHP. |

---

## 🚀 Como Executar

### 1. Pelo Menu Interativo no Terminal (Mais Fácil)

- **No Windows:**
  Dê dois cliques em [`run_tests.bat`](run_tests.bat) ou execute no PowerShell/CMD:
  ```cmd
  tests\run_tests.bat
  ```

- **No Linux / macOS:**
  ```bash
  chmod +x tests/*.sh
  ./tests/run_tests.sh
  ```

---

### 2. Pelo Dashboard Visual no Navegador
Abra diretamente o arquivo [`index.html`](index.html) no seu navegador:
* Terminal interativo com exibição dos Pokémons na tela digital.
* Disparo de eleição em massa com slider de eleitores e gráficos em tempo real.
* Execução da bateria de testes com visualização de status verde/vermelho por endpoint.

---

### 3. Executando Scripts Individuais via PHP CLI

#### A) Teste Automatizado da API REST
```bash
php tests/test_sistema_api.php http://localhost:8080
```
> Executa 12 casos de teste cobrindo registro unitário, lote, filtros, apuração, zerésima e re-seed.

#### B) Simulador do Terminal Eleitoral
```bash
# Modo Interativo (permite escolher votar individual ou sessão completa):
php tests/simulador_poke.php

# Modo Automático (executa 1 eleitor completo direto):
php tests/simulador_poke.php http://localhost:8080/backend/votos --auto
```

#### C) Teste de Carga e Eleição em Massa
```bash
# Sintaxe: php tests/simulador_eleicao_massa.php [Qtd Eleitores] [Concorrência] [URL API]
php tests/simulador_eleicao_massa.php 50 10 http://localhost:8080/backend/votos
```

#### D) Simulador de Teclado Virtual & Validador de Votos
```bash
php tests/simulador_teclado_matricial.php
```
> Valida máscaras de dígitos (5 para Dep. Estadual, 4 para Federal, 3 para Senador, 2 para Executivo) e teclas de controle (BRANCO, CORRIGE, CONFIRMA).
