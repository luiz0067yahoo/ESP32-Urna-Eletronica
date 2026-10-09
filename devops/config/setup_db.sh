#!/usr/bin/env bash
# ==============================================================================
# MYSQL SETUP & MIGRATION (LINUX / MACOS) - WITHOUT DOCKER
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  APP_LANG="EN"
fi

ENV_FILE="${PROJECT_ROOT}/.env"
if [ ! -f "$ENV_FILE" ] && [ -f "${PROJECT_ROOT}/.env.example" ]; then
  ENV_FILE="${PROJECT_ROOT}/.env.example"
fi

if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)
fi

DB_USER="${2:-${DB_USER:-root}}"
DB_PASS="${3:-${DB_PASS:-}}"
DB_NAME="${4:-${DB_NAME:-urna_eletronica}}"
DB_HOST="${DB_HOST:-localhost}"

echo "==================================================================="
[ "$APP_LANG" = "EN" ] && echo "[DEVOPS] Provisioning MySQL Database: '${DB_NAME}'"
[ "$APP_LANG" = "ES" ] && echo "[DEVOPS] Aprovisionando Base de Datos MySQL: '${DB_NAME}'"
[ "$APP_LANG" = "IT" ] && echo "[DEVOPS] Provisioning Database MySQL: '${DB_NAME}'"
[ "$APP_LANG" = "PT" ] && echo "[DEVOPS] Provisionando Banco de Dados MySQL: '${DB_NAME}'"
echo "==================================================================="

MYSQL_CMD="mysql -u ${DB_USER} -h ${DB_HOST}"
if [ -n "${DB_PASS}" ]; then
  MYSQL_CMD="${MYSQL_CMD} -p${DB_PASS}"
fi

$MYSQL_CMD -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true

php "${PROJECT_ROOT}/db/install.php"

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Database '${DB_NAME}' provisioned successfully!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Base de datos '${DB_NAME}' aprovisionada con éxito!"
[ "$APP_LANG" = "IT" ] && echo "✔ Database '${DB_NAME}' configurato con successo!"
[ "$APP_LANG" = "PT" ] && echo "✔ Banco de dados '${DB_NAME}' provisionado com sucesso!"
