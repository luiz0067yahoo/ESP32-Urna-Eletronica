#!/usr/bin/env bash
# ==============================================================================
# AUTOMATED GIT DEPLOY (LINUX / MACOS) - KUBERNETES
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
[ "$APP_LANG" = "EN" ] && echo "  ☸️ AUTOMATED GIT DEPLOY (KUBERNETES) - BRANCH: $BRANCH"
[ "$APP_LANG" = "ES" ] && echo "  ☸️ DESPLIEGUE AUTOMÁTICO VÍA GIT (KUBERNETES) - RAMA: $BRANCH"
[ "$APP_LANG" = "IT" ] && echo "  ☸️ DEPLOY AUTOMATICO VIA GIT (KUBERNETES) - BRANCH: $BRANCH"
[ "$APP_LANG" = "PT" ] && echo "  ☸️ DEPLOY AUTOMÁTICO VIA GIT (KUBERNETES) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"
[ "$APP_LANG" = "EN" ] && echo "1. Fetching Git updates..."
[ "$APP_LANG" = "ES" ] && echo "1. Obteniendo actualizaciones de Git..."
[ "$APP_LANG" = "IT" ] && echo "1. Recupero aggiornamenti da Git..."
[ "$APP_LANG" = "PT" ] && echo "1. Atualizando codigo do Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

[ "$APP_LANG" = "EN" ] && echo "2. Building Docker image..."
[ "$APP_LANG" = "ES" ] && echo "2. Construyendo imagen Docker..."
[ "$APP_LANG" = "IT" ] && echo "2. Compilazione immagine Docker..."
[ "$APP_LANG" = "PT" ] && echo "2. Construindo imagem Docker..."
docker build -t urna-app:latest -f "$PROJECT_ROOT/devops/docker/Dockerfile" "$PROJECT_ROOT" 2>/dev/null || podman build -t urna-app:latest -f "$PROJECT_ROOT/devops/docker/Dockerfile" "$PROJECT_ROOT"

[ "$APP_LANG" = "EN" ] && echo "3. Applying Kubernetes manifests with Kustomize..."
[ "$APP_LANG" = "ES" ] && echo "3. Aplicando manifiestos Kubernetes con Kustomize..."
[ "$APP_LANG" = "IT" ] && echo "3. Applicazione manifesti Kubernetes con Kustomize..."
[ "$APP_LANG" = "PT" ] && echo "3. Aplicando manifestos Kubernetes com Kustomize..."
kubectl apply -k "$SCRIPT_DIR"

[ "$APP_LANG" = "EN" ] && echo "4. Restarting deployment..."
[ "$APP_LANG" = "ES" ] && echo "4. Reiniciando despliegue..."
[ "$APP_LANG" = "IT" ] && echo "4. Riavvio deployment..."
[ "$APP_LANG" = "PT" ] && echo "4. Reiniciando deployment da aplicacao..."
kubectl rollout restart deployment/urna-app -n urna-eletronica

[ "$APP_LANG" = "EN" ] && echo "5. Waiting for rollout completion..."
[ "$APP_LANG" = "ES" ] && echo "5. Esperando finalización del rollout..."
[ "$APP_LANG" = "IT" ] && echo "5. Attesa completamento rollout..."
[ "$APP_LANG" = "PT" ] && echo "5. Aguardando conclusao do rollout..."
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Git Deploy on Kubernetes finished successfully!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Despliegue Git en Kubernetes finalizado con éxito!"
[ "$APP_LANG" = "IT" ] && echo "✔ Deploy Git su Kubernetes completato con successo!"
[ "$APP_LANG" = "PT" ] && echo "✔ Deploy via Git no Kubernetes finalizado com sucesso!"
kubectl get pods -n urna-eletronica
echo "=========================================================="
