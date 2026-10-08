#!/usr/bin/env bash
# ==============================================================================
# AUTOMATED GIT DEPLOY (LINUX / MACOS) - DOCKER
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
[ "$APP_LANG" = "EN" ] && echo "  🚀 AUTOMATED GIT DEPLOY (DOCKER) - BRANCH: $BRANCH"
[ "$APP_LANG" = "ES" ] && echo "  🚀 DESPLIEGUE AUTOMÁTICO VÍA GIT (DOCKER) - RAMA: $BRANCH"
[ "$APP_LANG" = "IT" ] && echo "  🚀 DEPLOY AUTOMATICO VIA GIT (DOCKER) - BRANCH: $BRANCH"
[ "$APP_LANG" = "PT" ] && echo "  🚀 DEPLOY AUTOMÁTICO VIA GIT (DOCKER) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"
[ "$APP_LANG" = "EN" ] && echo "1. Fetching Git updates..."
[ "$APP_LANG" = "ES" ] && echo "1. Obteniendo actualizaciones de Git..."
[ "$APP_LANG" = "IT" ] && echo "1. Recupero aggiornamenti da Git..."
[ "$APP_LANG" = "PT" ] && echo "1. Buscando atualizacoes do Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

cd "$SCRIPT_DIR"
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

[ "$APP_LANG" = "EN" ] && echo "2. Updating Docker containers..."
[ "$APP_LANG" = "ES" ] && echo "2. Actualizando contenedores Docker..."
[ "$APP_LANG" = "IT" ] && echo "2. Aggiornamento container Docker..."
[ "$APP_LANG" = "PT" ] && echo "2. Atualizando containers Docker..."
docker compose up -d --build --remove-orphans

[ "$APP_LANG" = "EN" ] && echo "3. Running DB migrations via PHP..."
[ "$APP_LANG" = "ES" ] && echo "3. Ejecutando migraciones de BD vía PHP..."
[ "$APP_LANG" = "IT" ] && echo "3. Esecuzione migrazioni DB tramite PHP..."
[ "$APP_LANG" = "PT" ] && echo "3. Executando migracoes do banco via PHP..."
sleep 5
docker compose exec -T app php db/install.php

[ "$APP_LANG" = "EN" ] && echo "4. Pruning unused images..."
[ "$APP_LANG" = "ES" ] && echo "4. Limpiando imágenes en desuso..."
[ "$APP_LANG" = "IT" ] && echo "4. Rimozione immagini inutilizzate..."
[ "$APP_LANG" = "PT" ] && echo "4. Limpando imagens antigas..."
docker image prune -f

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Git Deploy completed successfully!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Despliegue Git completado con éxito!"
[ "$APP_LANG" = "IT" ] && echo "✔ Deploy Git completato con successo!"
[ "$APP_LANG" = "PT" ] && echo "✔ Deploy via Git concluido com sucesso!"
docker compose ps
echo "=========================================================="
