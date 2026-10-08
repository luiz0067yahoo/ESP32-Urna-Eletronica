#!/usr/bin/env bash
# ==============================================================================
# DOCKER STOP (LINUX / MACOS) - POKÉMON ELECTRONIC VOTING MACHINE
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

[ "$APP_LANG" = "EN" ] && echo "Stopping Docker containers..."
[ "$APP_LANG" = "ES" ] && echo "Deteniendo contenedores Docker..."
[ "$APP_LANG" = "IT" ] && echo "Arresto dei container Docker..."
[ "$APP_LANG" = "PT" ] && echo "Parando containers Docker..."

docker compose down

[ "$APP_LANG" = "EN" ] && echo "✔ Containers stopped successfully."
[ "$APP_LANG" = "ES" ] && echo "✔ Contenedores detenidos con éxito."
[ "$APP_LANG" = "IT" ] && echo "✔ Container arrestati con successo."
[ "$APP_LANG" = "PT" ] && echo "✔ Containers finalizados com sucesso."
