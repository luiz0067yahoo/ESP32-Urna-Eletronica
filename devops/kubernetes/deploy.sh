#!/usr/bin/env bash
# ==============================================================================
# KUBERNETES DEPLOY (LINUX / MACOS) - POKÉMON ELECTRONIC VOTING MACHINE
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  echo "=========================================================="
  echo "  ☸️ KUBERNETES DEPLOY LAUNCHER"
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

echo "=========================================================="
[ "$APP_LANG" = "EN" ] && echo "  ☸️ KUBERNETES DEPLOY - POKÉMON ELECTRONIC VOTING MACHINE"
[ "$APP_LANG" = "ES" ] && echo "  ☸️ DESPLIEGUE EN KUBERNETES - URNA ELECTRÓNICA POKÉMON"
[ "$APP_LANG" = "IT" ] && echo "  ☸️ DEPLOY KUBERNETES - URNA ELETTRONICA POKÉMON"
[ "$APP_LANG" = "PT" ] && echo "  ☸️ DEPLOY KUBERNETES - URNA ELETRÔNICA POKÉMON"
echo "=========================================================="

if ! command -v kubectl >/dev/null 2>&1; then
  echo "[ERROR] 'kubectl' command not found in PATH."
  exit 1
fi

[ "$APP_LANG" = "EN" ] && echo "1. Building local container image urna-app:latest..."
[ "$APP_LANG" = "ES" ] && echo "1. Construyendo imagen local urna-app:latest..."
[ "$APP_LANG" = "IT" ] && echo "1. Compilazione immagine locale urna-app:latest..."
[ "$APP_LANG" = "PT" ] && echo "1. Construindo imagem local urna-app:latest..."
docker build -t urna-app:latest -f "$PROJECT_ROOT/devops/docker/Dockerfile" "$PROJECT_ROOT" 2>/dev/null || podman build -t urna-app:latest -f "$PROJECT_ROOT/devops/docker/Dockerfile" "$PROJECT_ROOT"

cd "$SCRIPT_DIR"
[ "$APP_LANG" = "EN" ] && echo "2. Applying Kubernetes manifests with Kustomize..."
[ "$APP_LANG" = "ES" ] && echo "2. Aplicando manifiestos Kubernetes con Kustomize..."
[ "$APP_LANG" = "IT" ] && echo "2. Applicazione manifesti Kubernetes con Kustomize..."
[ "$APP_LANG" = "PT" ] && echo "2. Aplicando manifestos Kubernetes com Kustomize..."
kubectl apply -k .

[ "$APP_LANG" = "EN" ] && echo "3. Waiting for database rollout..."
[ "$APP_LANG" = "ES" ] && echo "3. Esperando que la base de datos esté lista..."
[ "$APP_LANG" = "IT" ] && echo "3. Attesa disponibilità database..."
[ "$APP_LANG" = "PT" ] && echo "3. Aguardando banco de dados ficar pronto..."
kubectl rollout status deployment/urna-db -n urna-eletronica --timeout=120s

[ "$APP_LANG" = "EN" ] && echo "4. Waiting for application rollout..."
[ "$APP_LANG" = "ES" ] && echo "4. Esperando que la aplicación esté lista..."
[ "$APP_LANG" = "IT" ] && echo "4. Attesa disponibilità applicazione..."
[ "$APP_LANG" = "PT" ] && echo "4. Aguardando aplicacao ficar pronta..."
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo ""
if [ "$APP_LANG" = "EN" ]; then
  echo "✔ Deploy successful in namespace 'urna-eletronica'!"
  echo "📋 How to access:"
  echo "   Option 1: Via NodePort on port 30080: http://localhost:30080/frontend/index.html"
  echo "   Option 2: Via Port-Forward: kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica"
  echo "Check pods: kubectl get pods -n urna-eletronica"
  echo "Remove all: ./destroy.sh"
elif [ "$APP_LANG" = "ES" ]; then
  echo "✔ ¡Despliegue exitoso en el namespace 'urna-eletronica'!"
  echo "📋 Cómo acceder:"
  echo "   Opción 1: NodePort en puerto 30080: http://localhost:30080/frontend/index.html"
  echo "   Opción 2: Port-Forward: kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica"
elif [ "$APP_LANG" = "IT" ]; then
  echo "✔ Deploy completato con successo nel namespace 'urna-eletronica'!"
  echo "📋 Come accedere:"
  echo "   Opzione 1: NodePort su porta 30080: http://localhost:30080/frontend/index.html"
  echo "   Opzione 2: Port-Forward: kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica"
else
  echo "✔ Deploy realizado com sucesso no namespace 'urna-eletronica'!"
  echo "📋 Como acessar a aplicação:"
  echo "   Opção 1: Via NodePort na porta 30080: http://localhost:30080/frontend/index.html"
  echo "   Opção 2: Via Port-Forward: kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica"
fi
echo "=========================================================="
