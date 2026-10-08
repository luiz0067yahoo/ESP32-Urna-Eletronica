#!/usr/bin/env bash
# ==============================================================================
# PODMAN STOP COMPOSE (LINUX / MACOS)
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

[ "$APP_LANG" = "EN" ] && echo "Stopping Podman Compose services..."
[ "$APP_LANG" = "ES" ] && echo "Deteniendo servicios de Podman Compose..."
[ "$APP_LANG" = "IT" ] && echo "Arresto dei servizi Podman Compose..."
[ "$APP_LANG" = "PT" ] && echo "Parando servicos do Podman Compose..."

if command -v podman-compose >/dev/null 2>&1; then
  podman-compose -f podman-compose.yml down
else
  podman compose -f podman-compose.yml down
fi

[ "$APP_LANG" = "EN" ] && echo "✔ Services stopped."
[ "$APP_LANG" = "ES" ] && echo "✔ Servicios detenidos."
[ "$APP_LANG" = "IT" ] && echo "✔ Servizi arrestati."
[ "$APP_LANG" = "PT" ] && echo "✔ Servicos finalizados."
