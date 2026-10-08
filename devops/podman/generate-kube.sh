#!/usr/bin/env bash
# ==============================================================================
# GENERATE KUBERNETES MANIFEST FROM PODMAN POD (LINUX / MACOS)
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
POD_NAME="urna-pod"
OUTPUT_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/podman-kube-exported.yaml"

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

if ! podman pod exists "$POD_NAME" 2>/dev/null; then
  if [ "$APP_LANG" = "EN" ]; then
    echo "❌ Pod '$POD_NAME' must be running to generate the manifest."
    echo "Run first: ./start-pod.sh"
  elif [ "$APP_LANG" = "ES" ]; then
    echo "❌ El Pod '$POD_NAME' debe estar ejecutándose para generar el manifiesto."
    echo "Ejecuta primero: ./start-pod.sh"
  elif [ "$APP_LANG" = "IT" ]; then
    echo "❌ Il Pod '$POD_NAME' deve essere in esecuzione per generare il manifesto."
    echo "Esegui prima: ./start-pod.sh"
  else
    echo "❌ O Pod '$POD_NAME' precisa estar em execução para gerar o manifesto."
    echo "Execute primeiro: ./start-pod.sh"
  fi
  exit 1
fi

[ "$APP_LANG" = "EN" ] && echo "Exporting Podman Pod '$POD_NAME' to Kubernetes YAML manifest..."
[ "$APP_LANG" = "ES" ] && echo "Exportando Podman Pod '$POD_NAME' a manifiesto Kubernetes YAML..."
[ "$APP_LANG" = "IT" ] && echo "Esportazione Podman Pod '$POD_NAME' in manifesto Kubernetes YAML..."
[ "$APP_LANG" = "PT" ] && echo "Exportando Podman Pod '$POD_NAME' para manifesto Kubernetes YAML..."
podman generate kube "$POD_NAME" > "$OUTPUT_FILE"

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Manifest generated at: $OUTPUT_FILE"
[ "$APP_LANG" = "ES" ] && echo "✔ Manifiesto generado en: $OUTPUT_FILE"
[ "$APP_LANG" = "IT" ] && echo "✔ Manifesto generato in: $OUTPUT_FILE"
[ "$APP_LANG" = "PT" ] && echo "✔ Manifesto gerado em: $OUTPUT_FILE"
echo "Deploy with: kubectl apply -f $OUTPUT_FILE"
