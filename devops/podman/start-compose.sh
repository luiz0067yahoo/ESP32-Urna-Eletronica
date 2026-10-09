#!/usr/bin/env bash
# ==============================================================================
# PODMAN COMPOSE LAUNCHER (LINUX / MACOS)
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
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

PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [ ! -f "$PROJECT_ROOT/.env" ] && [ -f "$PROJECT_ROOT/.env.example" ]; then
  cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
fi

echo "=========================================================="
[ "$APP_LANG" = "EN" ] && echo "  🚀 STARTING WITH PODMAN COMPOSE"
[ "$APP_LANG" = "ES" ] && echo "  🚀 INICIANDO CON PODMAN COMPOSE"
[ "$APP_LANG" = "IT" ] && echo "  🚀 AVVIO CON PODMAN COMPOSE"
[ "$APP_LANG" = "PT" ] && echo "  🚀 INICIANDO COM PODMAN COMPOSE"
echo "=========================================================="

if command -v podman-compose >/dev/null 2>&1; then
  podman-compose --env-file "$PROJECT_ROOT/.env" -f podman-compose.yml up -d --build
else
  podman compose --env-file "$PROJECT_ROOT/.env" -f podman-compose.yml up -d --build
fi

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Services started successfully!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Servicios iniciados con éxito!"
[ "$APP_LANG" = "IT" ] && echo "✔ Servizi avviati con successo!"
[ "$APP_LANG" = "PT" ] && echo "✔ Servicos iniciados com sucesso!"
echo "   👉 Voting Booth: http://localhost:8080/frontend/index.html"
echo "   👉 Live Results: http://localhost:8080/frontend/apuracao.html"
echo "   👉 RESTful API:  http://localhost:8080/backend/apuracao"
