#!/usr/bin/env bash
# ==============================================================================
# INICIALIZADOR COMPLETO: FRONTEND + BACKEND + MYSQL (SEM DOCKER)
# Compatível com ambiente Piku e execução local em Linux/macOS
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Carrega variáveis do arquivo ENV do Piku se existir
if [ -f "${SCRIPT_DIR}/ENV" ]; then
    export $(grep -v '^#' "${SCRIPT_DIR}/ENV" | grep -v '^$' | xargs)
fi

# Carrega preferencialmente backend/.env, com fallback para backend/.env.example
ENV_FILE="${PROJECT_ROOT}/backend/.env"
if [ ! -f "$ENV_FILE" ] && [ -f "${PROJECT_ROOT}/backend/.env.example" ]; then
    ENV_FILE="${PROJECT_ROOT}/backend/.env.example"
fi

if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)
fi

PORT="${PORT:-8080}"
DB_HOST="${DB_HOST:-localhost}"
DB_NAME="${DB_NAME:-urna_eletronica}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-}"

echo "==================================================================="
echo "  🗳️ URNA ELETRÔNICA POKÉMON - INICIALIZAÇÃO NATIVA (SEM DOCKER)"
echo "==================================================================="

# 1. Verifica se o serviço do MySQL/MariaDB está rodando no sistema
echo "1. Verificando serviço MySQL local..."
if command -v systemctl >/dev/null 2>&1; then
    if ! systemctl is-active --quiet mysql && ! systemctl is-active --quiet mariadb; then
        echo "   -> Iniciando serviço MySQL/MariaDB..."
        sudo systemctl start mysql 2>/dev/null || sudo systemctl start mariadb 2>/dev/null || true
    fi
fi

# 2. Executa o provisionamento do banco se necessário
if command -v mysql >/dev/null 2>&1; then
    echo "2. Checando tabelas do banco de dados '${DB_NAME}'..."
    bash "${SCRIPT_DIR}/setup_db.sh" "${DB_USER}" "${DB_PASS}" "${DB_NAME}" || true
else
    echo "   -> [Aviso] Cliente 'mysql' não encontrado no PATH. Certifique-se de que o banco está criado."
fi

# 3. Inicia o servidor web nativo unificado (Frontend + Backend PHP)
echo "3. Iniciando Servidor Web na porta ${PORT}..."
echo ""
echo "   👉 Urna Eletrônica: http://localhost:${PORT}/frontend/index.html"
echo "   👉 Apuração ao Vivo: http://localhost:${PORT}/frontend/apuracao.html"
echo "   👉 API REST Backend: http://localhost:${PORT}/backend/apuracao"
echo ""
echo "Pressione Ctrl+C para encerrar o servidor."
echo "==================================================================="

cd "${PROJECT_ROOT}"
php -S 0.0.0.0:${PORT}
