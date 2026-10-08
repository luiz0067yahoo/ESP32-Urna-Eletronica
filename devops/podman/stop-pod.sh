#!/usr/bin/env bash
# ==============================================================================
# PODMAN STOP POD (LINUX / MACOS)
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
POD_NAME="urna-pod"

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

[ "$APP_LANG" = "EN" ] && echo "Stopping and removing Podman Pod '$POD_NAME'..."
[ "$APP_LANG" = "ES" ] && echo "Deteniendo y eliminando Podman Pod '$POD_NAME'..."
[ "$APP_LANG" = "IT" ] && echo "Arresto e rimozione Podman Pod '$POD_NAME'..."
[ "$APP_LANG" = "PT" ] && echo "Parando e removendo Podman Pod '$POD_NAME'..."

podman pod rm -f "$POD_NAME" 2>/dev/null || true

[ "$APP_LANG" = "EN" ] && echo "✔ Pod '$POD_NAME' stopped successfully."
[ "$APP_LANG" = "ES" ] && echo "✔ Pod '$POD_NAME' detenido con éxito."
[ "$APP_LANG" = "IT" ] && echo "✔ Pod '$POD_NAME' arrestato con successo."
[ "$APP_LANG" = "PT" ] && echo "✔ Pod '$POD_NAME' finalizado com sucesso."
