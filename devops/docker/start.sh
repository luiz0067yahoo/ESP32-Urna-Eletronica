#!/usr/bin/env bash
# ==============================================================================
# DOCKER LAUNCHER (LINUX / MACOS) - POKÉMON ELECTRONIC VOTING MACHINE
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  echo "=========================================================="
  echo "  🐳 DOCKER ENVIRONMENT LAUNCHER"
  echo "=========================================================="
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

if [ ! -f .env ] && [ -f .env.example ]; then
  [ "$APP_LANG" = "EN" ] && echo "Creating .env file from .env.example..."
  [ "$APP_LANG" = "ES" ] && echo "Creando archivo .env desde .env.example..."
  [ "$APP_LANG" = "IT" ] && echo "Creazione file .env da .env.example..."
  [ "$APP_LANG" = "PT" ] && echo "Criando arquivo .env a partir de .env.example..."
  cp .env.example .env
fi

echo "=========================================================="
[ "$APP_LANG" = "EN" ] && echo "  🚀 STARTING DOCKER ENVIRONMENT"
[ "$APP_LANG" = "ES" ] && echo "  🚀 INICIANDO ENTORNO DOCKER"
[ "$APP_LANG" = "IT" ] && echo "  🚀 AVVIO AMBIENTE DOCKER"
[ "$APP_LANG" = "PT" ] && echo "  🚀 INICIANDO AMBIENTE DOCKER"
echo "=========================================================="

docker compose up -d --build

echo ""
if [ "$APP_LANG" = "EN" ]; then
  echo "✔ Containers started successfully!"
  echo "   👉 Voting Booth:     http://localhost:8080/frontend/index.html"
  echo "   👉 Live Results:     http://localhost:8080/frontend/apuracao.html"
  echo "   👉 RESTful API:      http://localhost:8080/backend/apuracao"
  echo "   👉 phpMyAdmin (DB):  http://localhost:8081"
  echo ""
  echo "To view logs: docker compose logs -f"
  echo "To stop services: ./stop.sh"
elif [ "$APP_LANG" = "ES" ]; then
  echo "✔ ¡Contenedores iniciados con éxito!"
  echo "   👉 Cabina de Votación: http://localhost:8080/frontend/index.html"
  echo "   👉 Escrutinio en Vivo: http://localhost:8080/frontend/apuracao.html"
  echo "   👉 API REST Backend:   http://localhost:8080/backend/apuracao"
  echo "   👉 phpMyAdmin (BD):    http://localhost:8081"
  echo ""
  echo "Para ver logs: docker compose logs -f"
  echo "Para detener: ./stop.sh"
elif [ "$APP_LANG" = "IT" ]; then
  echo "✔ Container avviati con successo!"
  echo "   👉 Cabina Elettorale:  http://localhost:8080/frontend/index.html"
  echo "   👉 Scrutinio dal Vivo: http://localhost:8080/frontend/apuracao.html"
  echo "   👉 API REST Backend:   http://localhost:8080/backend/apuracao"
  echo "   👉 phpMyAdmin (DB):    http://localhost:8081"
  echo ""
  echo "Per visualizzare i log: docker compose logs -f"
  echo "Per arrestare: ./stop.sh"
else
  echo "✔ Containers iniciados com sucesso!"
  echo "   👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html"
  echo "   👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html"
  echo "   👉 API REST Backend: http://localhost:8080/backend/apuracao"
  echo "   👉 phpMyAdmin (DB):  http://localhost:8081"
  echo ""
  echo "Para visualizar os logs: docker compose logs -f"
  echo "Para parar os serviços: ./stop.sh"
fi
echo "=========================================================="
