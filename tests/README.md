# 🧪 Testes de Sistema & Simuladores • Urna Eletrônica Pokémon

Esta pasta contém o ecossistema completo de **testes de sistema**, **simuladores do terminal eleitoral web**, **testes de estresse/carga** e um **dashboard visual interativo** para a Urna Eletrônica Pokémon.

---

## 📁 Arquivos da Pasta `tests/`

| Arquivo | Descrição |
| :--- | :--- |
| **`index.html`** | 🌐 **Dashboard Visual Interativo:** Painel completo no navegador com terminal eleitoral interativo, sons do TSE (Web Audio API), teste de carga com barra de progresso e apuração em tempo real. |
| **`simulador_poke.py`** | 🤖 **Simulador do Terminal Eleitoral:** Emula o cliente web da Urna Eletrônica transmitindo votos via HTTP POST para a API REST, com medição de latência e sons de confirmação. |
| **`simulador_eleicao_massa.py`** | ⚡ **Simulador de Eleição em Massa (Teste de Carga):** Simula centenas de eleitores votando em paralelo via multithreading com cálculo de RPS, latência p95/p99 e taxa de sucesso. |
| **`simulador_teclado_matricial.py`**| ⌨️ **Simulador de Teclado Virtual & Validador de Votos:** Emula as regras de contagem de dígitos por cargo eleitoral, debounce de software e teclas de ação (BRANCO, CORRIGE, CONFIRMA). |
| **`test_sistema_api.py`** | 🧪 **Suíte Automatizada de Testes de Sistema:** Validação completa de contratos da API RESTful (HTTP 200, 201, 400, 404, Zerésima eleitoral e re-seed). |
| **`run_tests.bat`** | 🚀 **Menu Interativo (Windows):** Permite escolher e rodar qualquer teste em 1 clique. |
| **`run_tests.sh`** | 🐧 **Menu Interativo (Linux/macOS):** Script executável para rodar a suíte no terminal. |

---

## 🚀 Como Executar

### 1. Pelo Dashboard Visual no Navegador (Mais Fácil e Completo)
Abra diretamente o arquivo [`index.html`](index.html) no seu navegador (Google Chrome, Edge, Firefox):
* Terminal interativo com exibição dos Pokémons na tela digital.
* Disparo de eleição em massa com slider de eleitores e gráficos em tempo real.
* Execução da bateria de testes com visualização de status verde/vermelho por endpoint.

---

### 2. Pelo Menu Interativo no Terminal

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

### 3. Executando Scripts Individuais via Python

#### A) Teste Automatizado da API REST
```bash
python tests/test_sistema_api.py http://localhost:8080
```
> Executa 12 casos de teste cobrindo registro unitário, lote, filtros, apuração, zerésima e re-seed.

#### B) Simulador do Terminal Eleitoral
```bash
# Modo Interativo (permite escolher votar individual ou sessão completa):
python tests/simulador_poke.py

# Modo Automático (executa 1 eleitor completo direto):
python tests/simulador_poke.py http://localhost:8080/backend/votos --auto
```

#### C) Teste de Carga e Eleição em Massa
```bash
# Sintaxe: python tests/simulador_eleicao_massa.py [Qtd Eleitores] [Threads] [URL API]
python tests/simulador_eleicao_massa.py 50 10
```

#### D) Simulador de Teclado Virtual & Validador de Votos
```bash
python tests/simulador_teclado_matricial.py
```
> Valida máscaras de dígitos (5 para Dep. Estadual, 4 para Federal, 3 para Senador, 2 para Executivo) e teclas de controle (BRANCO, CORRIGE, CONFIRMA).
