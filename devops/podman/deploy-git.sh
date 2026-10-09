#!/usr/bin/env bash
# ==============================================================================
# AUTOMATED GIT DEPLOY (LINUX / MACOS) - PODMAN
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BRANCH="${2:-main}"

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

echo "=========================================================="
[ "$APP_LANG" = "EN" ] && echo "  🚀 AUTOMATED GIT DEPLOY (PODMAN) - BRANCH: $BRANCH"
[ "$APP_LANG" = "ES" ] && echo "  🚀 DESPLIEGUE AUTOMÁTICO VÍA GIT (PODMAN) - RAMA: $BRANCH"
[ "$APP_LANG" = "IT" ] && echo "  🚀 DEPLOY AUTOMATICO VIA GIT (PODMAN) - BRANCH: $BRANCH"
[ "$APP_LANG" = "PT" ] && echo "  🚀 DEPLOY AUTOMÁTICO VIA GIT (PODMAN) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"
[ "$APP_LANG" = "EN" ] && echo "1. Fetching Git updates..."
[ "$APP_LANG" = "ES" ] && echo "1. Obteniendo actualizaciones de Git..."
[ "$APP_LANG" = "IT" ] && echo "1. Recupero aggiornamenti da Git..."
[ "$APP_LANG" = "PT" ] && echo "1. Atualizando codigo do Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

cd "$SCRIPT_DIR"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [ ! -f "$PROJECT_ROOT/.env" ] && [ -f "$PROJECT_ROOT/.env.example" ]; then
  cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
fi

[ "$APP_LANG" = "EN" ] && echo "2. Updating Podman containers..."
[ "$APP_LANG" = "ES" ] && echo "2. Actualizando contenedores Podman..."
[ "$APP_LANG" = "IT" ] && echo "2. Aggiornamento container Podman..."
[ "$APP_LANG" = "PT" ] && echo "2. Atualizando containers Podman..."

if command -v podman-compose >/dev/null 2>&1; then
  podman-compose --env-file "$PROJECT_ROOT/.env" -f podman-compose.yml up -d --build
  sleep 5
  podman exec urna_podman_app php db/install.php
else
  bash start-pod.sh "$APP_LANG"
  sleep 5
  podman exec urna-app php db/install.php
fi

[ "$APP_LANG" = "EN" ] && echo "3. Pruning unused images..."
[ "$APP_LANG" = "ES" ] && echo "3. Limpiando imágenes antiguas..."
[ "$APP_LANG" = "IT" ] && echo "3. Rimozione immagini inutilizzate..."
[ "$APP_LANG" = "PT" ] && echo "3. Limpando imagens antigas..."
podman image prune -f

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Git Deploy on Podman finished!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Despliegue Git en Podman finalizado!"
[ "$APP_LANG" = "IT" ] && echo "✔ Deploy Git su Podman completato!"
[ "$APP_LANG" = "PT" ] && echo "✔ Deploy via Git no Podman finalizado!"
echo "=========================================================="
