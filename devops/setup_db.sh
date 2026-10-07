#!/usr/bin/env bash
# ==============================================================================
# SCRIPT DE CONFIGURAÇÃO E MIGRAÇÃO DO BANCO MYSQL (SEM DOCKER)
# Execução: bash devops/setup_db.sh [usuario] [senha] [banco]
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Carrega preferencialmente backend/.env, com fallback para backend/.env.example
ENV_FILE="${PROJECT_ROOT}/backend/.env"
if [ ! -f "$ENV_FILE" ] && [ -f "${PROJECT_ROOT}/backend/.env.example" ]; then
    ENV_FILE="${PROJECT_ROOT}/backend/.env.example"
fi

if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)
fi

DB_USER="${1:-${DB_USER:-root}}"
DB_PASS="${2:-${DB_PASS:-}}"
DB_NAME="${3:-${DB_NAME:-urna_eletronica}}"
DB_HOST="${DB_HOST:-localhost}"

echo "=== [DEVOPS] Provisionando Banco de Dados MySQL: '${DB_NAME}' (Usando: ${ENV_FILE}) ==="

# Monta o comando de conexão mysql com ou sem senha
MYSQL_CMD="mysql -u ${DB_USER} -h ${DB_HOST}"
if [ -n "${DB_PASS}" ]; then
    MYSQL_CMD="${MYSQL_CMD} -p${DB_PASS}"
fi

# 1. Cria o banco de dados se não existir
echo "1. Criando banco de dados '${DB_NAME}' (se não existir)..."
$MYSQL_CMD -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Executa o instalador inteligente (verifica migração e seed)
echo "2. Executando instalador inteligente: db/install.php..."
php "${PROJECT_ROOT}/db/install.php"

echo "✔ Banco de dados '${DB_NAME}' provisionado com sucesso (sem Docker)!"
