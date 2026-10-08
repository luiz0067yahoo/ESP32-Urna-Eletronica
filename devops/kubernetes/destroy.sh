#!/usr/bin/env bash
# ==============================================================================
# DESTROY KUBERNETES DEPLOYMENT (LINUX / MACOS)
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

[ "$APP_LANG" = "EN" ] && echo "Removing all Kubernetes resources for 'urna-eletronica'..."
[ "$APP_LANG" = "ES" ] && echo "Eliminando todos los recursos de Kubernetes para 'urna-eletronica'..."
[ "$APP_LANG" = "IT" ] && echo "Rimozione di tutte le risorse Kubernetes per 'urna-eletronica'..."
[ "$APP_LANG" = "PT" ] && echo "Removendo todos os recursos do Kubernetes no namespace 'urna-eletronica'..."

kubectl delete -k . --ignore-not-found=true

[ "$APP_LANG" = "EN" ] && echo "✔ All resources removed successfully."
[ "$APP_LANG" = "ES" ] && echo "✔ Todos los recursos eliminados con éxito."
[ "$APP_LANG" = "IT" ] && echo "✔ Tutte le risorse rimosse con successo."
[ "$APP_LANG" = "PT" ] && echo "✔ Todos os recursos foram removidos com sucesso."
