#!/usr/bin/env bash
# ==============================================================================
# PODMAN NATIVE POD LAUNCHER (LINUX / MACOS)
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

POD_NAME="urna-pod"
APP_IMAGE="urna-app:podman"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  echo "=========================================================="
  echo "  🦭 PODMAN NATIVE POD LAUNCHER"
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
[ "$APP_LANG" = "EN" ] && echo "  🚀 STARTING PODMAN NATIVE POD ($POD_NAME)"
[ "$APP_LANG" = "ES" ] && echo "  🚀 INICIANDO POD NATIVO PODMAN ($POD_NAME)"
[ "$APP_LANG" = "IT" ] && echo "  🚀 AVVIO POD NATIVO PODMAN ($POD_NAME)"
[ "$APP_LANG" = "PT" ] && echo "  🚀 INICIANDO POD NATIVO PODMAN ($POD_NAME)"
echo "=========================================================="

if [ ! -f "$PROJECT_ROOT/.env" ] && [ -f "$PROJECT_ROOT/.env.example" ]; then
  cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
fi

# Carrega variáveis do .env da raiz
if [ -f "$PROJECT_ROOT/.env" ]; then
  set -a
  source <(grep -v '^#' "$PROJECT_ROOT/.env" | grep -v '^$' | sed -e 's/\r$//')
  set +a
fi

DB_NAME="${DB_NAME:-urna}"
DB_USER="${DB_USER:-urna}"
DB_PASS="${DB_PASS:-urna123}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-rootpassword}"
APP_PORT="${APP_PORT:-8080}"
DB_PORT="${DB_PORT:-3306}"

podman pod rm -f "$POD_NAME" 2>/dev/null || true

[ "$APP_LANG" = "EN" ] && echo "1. Creating Pod '$POD_NAME' on port $APP_PORT..."
[ "$APP_LANG" = "ES" ] && echo "1. Creando Pod '$POD_NAME' en puerto $APP_PORT..."
[ "$APP_LANG" = "IT" ] && echo "1. Creazione Pod '$POD_NAME' sulla porta $APP_PORT..."
[ "$APP_LANG" = "PT" ] && echo "1. Criando Pod '$POD_NAME' com porta $APP_PORT..."
podman pod create --name "$POD_NAME" -p "$APP_PORT":80

[ "$APP_LANG" = "EN" ] && echo "2. Starting MariaDB inside Pod..."
[ "$APP_LANG" = "ES" ] && echo "2. Iniciando MariaDB dentro del Pod..."
[ "$APP_LANG" = "IT" ] && echo "2. Avvio MariaDB nel Pod..."
[ "$APP_LANG" = "PT" ] && echo "2. Subindo MariaDB no Pod..."
podman run -d --name urna-db --pod "$POD_NAME" --restart unless-stopped \
  -e MYSQL_DATABASE="$DB_NAME" -e MYSQL_USER="$DB_USER" -e MYSQL_PASSWORD="$DB_PASS" \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" -v urna_pod_db_data:/var/lib/mysql:Z \
  docker.io/library/mariadb:10.11

[ "$APP_LANG" = "EN" ] && echo "3. Building $APP_IMAGE image..."
[ "$APP_LANG" = "ES" ] && echo "3. Construyendo imagen $APP_IMAGE..."
[ "$APP_LANG" = "IT" ] && echo "3. Compilazione immagine $APP_IMAGE..."
[ "$APP_LANG" = "PT" ] && echo "3. Construindo imagem $APP_IMAGE..."
podman build -t "$APP_IMAGE" -f "$SCRIPT_DIR/Containerfile" "$PROJECT_ROOT"

[ "$APP_LANG" = "EN" ] && echo "4. Starting Ballot Box app inside Pod..."
[ "$APP_LANG" = "ES" ] && echo "4. Iniciando aplicación de la Urna en el Pod..."
[ "$APP_LANG" = "IT" ] && echo "4. Avvio applicazione Urna nel Pod..."
[ "$APP_LANG" = "PT" ] && echo "4. Subindo aplicacao Urna no Pod..."
podman run -d --name urna-app --pod "$POD_NAME" --restart unless-stopped \
  -e DB_HOST=127.0.0.1 -e DB_PORT="$DB_PORT" -e DB_NAME="$DB_NAME" -e DB_USER="$DB_USER" -e DB_PASS="$DB_PASS" \
  "$APP_IMAGE"

echo ""
[ "$APP_LANG" = "EN" ] && echo "✔ Podman Pod '$POD_NAME' started successfully!"
[ "$APP_LANG" = "ES" ] && echo "✔ ¡Podman Pod '$POD_NAME' iniciado con éxito!"
[ "$APP_LANG" = "IT" ] && echo "✔ Podman Pod '$POD_NAME' avviato con successo!"
[ "$APP_LANG" = "PT" ] && echo "✔ Podman Pod '$POD_NAME' iniciado com sucesso!"
echo "   👉 Voting Booth: http://localhost:8080/frontend/index.html"
echo "   👉 Live Results: http://localhost:8080/frontend/apuracao.html"
echo "   👉 RESTful API:  http://localhost:8080/backend/apuracao"
