#!/usr/bin/env bash
# ==============================================================================
# NATIVE LAUNCHER (LINUX / MACOS) - POKÉMON ELECTRONIC VOTING MACHINE
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  echo "==================================================================="
  echo "  🗳️ POKÉMON BALLOT BOX - NATIVE LAUNCHER"
  echo "==================================================================="
  echo " Select Language / Selecione o Idioma / Seleccione / Seleziona:"
  echo "  [1] 🇺🇸 English (Default)"
  echo "  [2] 🇧🇷 Português"
  echo "  [3] 🇪🇸 Español"
  echo "  [4] 🇮🇹 Italiano"
  read -p "Choice [1-4] (Press ENTER for English): " LANG_CHOICE
  case "$LANG_CHOICE" in
    2) APP_LANG="PT" ;;
    3) APP_LANG="ES" ;;
    4) APP_LANG="IT" ;;
    *) APP_LANG="EN" ;;
  esac
fi

if [ -f "${SCRIPT_DIR}/ENV" ]; then
  export $(grep -v '^#' "${SCRIPT_DIR}/ENV" | grep -v '^$' | xargs)
fi

ENV_FILE="${PROJECT_ROOT}/.env"
if [ ! -f "$ENV_FILE" ] && [ -f "${PROJECT_ROOT}/.env.example" ]; then
  ENV_FILE="${PROJECT_ROOT}/.env.example"
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
[ "$APP_LANG" = "EN" ] && echo "  🗳️ POKÉMON BALLOT BOX - NATIVE LAUNCH (WITHOUT DOCKER)"
[ "$APP_LANG" = "ES" ] && echo "  🗳️ URNA ELECTRÓNICA POKÉMON - INICIO NATIVO (SIN DOCKER)"
[ "$APP_LANG" = "IT" ] && echo "  🗳️ URNA ELETTRONICA POKÉMON - AVVIO NATIVO (SENZA DOCKER)"
[ "$APP_LANG" = "PT" ] && echo "  🗳️ URNA ELETRÔNICA POKÉMON - INICIALIZAÇÃO NATIVA (SEM DOCKER)"
echo "==================================================================="

[ "$APP_LANG" = "EN" ] && echo "1. Checking local MySQL service..."
[ "$APP_LANG" = "ES" ] && echo "1. Comprobando servicio MySQL local..."
[ "$APP_LANG" = "IT" ] && echo "1. Verifica servizio MySQL locale..."
[ "$APP_LANG" = "PT" ] && echo "1. Verificando serviço MySQL local..."
if command -v systemctl >/dev/null 2>&1; then
  if ! systemctl is-active --quiet mysql && ! systemctl is-active --quiet mariadb; then
    sudo systemctl start mysql 2>/dev/null || sudo systemctl start mariadb 2>/dev/null || true
  fi
fi

if command -v mysql >/dev/null 2>&1; then
  bash "${SCRIPT_DIR}/setup_db.sh" "${APP_LANG}" "${DB_USER}" "${DB_PASS}" "${DB_NAME}" || true
else
  [ "$APP_LANG" = "EN" ] && echo "   -> MySQL client not in PATH. Assuming database already provisioned."
  [ "$APP_LANG" = "ES" ] && echo "   -> Cliente MySQL ausente en PATH. Asumiendo BD aprovisionada."
  [ "$APP_LANG" = "IT" ] && echo "   -> Client MySQL non nel PATH. Database assunto come configurato."
  [ "$APP_LANG" = "PT" ] && echo "   -> Cliente MySQL ausente no PATH. Assumindo banco ja configurado."
fi

echo ""
[ "$APP_LANG" = "EN" ] && echo "2. Starting PHP Web Server on port ${PORT}..."
[ "$APP_LANG" = "ES" ] && echo "2. Iniciando Servidor Web PHP en puerto ${PORT}..."
[ "$APP_LANG" = "IT" ] && echo "2. Avvio Server Web PHP su porta ${PORT}..."
[ "$APP_LANG" = "PT" ] && echo "2. Iniciando Servidor Web PHP na porta ${PORT}..."
echo ""
echo "   👉 Urna/Booth:  http://localhost:${PORT}/frontend/index.html"
echo "   👉 Live Results: http://localhost:${PORT}/frontend/apuracao.html"
echo "   👉 RESTful API:  http://localhost:${PORT}/backend/apuracao"
echo ""

cd "$PROJECT_ROOT"
which xdg-open >/dev/null 2>&1 && xdg-open "http://localhost:${PORT}/frontend/index.html" || true
exec php -S "0.0.0.0:${PORT}"
