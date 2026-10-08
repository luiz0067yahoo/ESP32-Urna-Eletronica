#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f .env ] && [ -f .env.example ]; then
    echo "Criando .env a partir de .env.example..."
    cp .env.example .env
fi

echo "=========================================================="
echo "  🚀 INICIANDO COM PODMAN COMPOSE"
echo "=========================================================="

podman-compose -f podman-compose.yml up -d --build

echo ""
echo "✔ Serviços iniciados com Podman Compose!"
echo "   👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html"
echo "   👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html"
echo "   👉 API REST Backend: http://localhost:8080/backend/apuracao"
echo ""
echo "Para parar: ./stop-compose.sh"
echo "=========================================================="
