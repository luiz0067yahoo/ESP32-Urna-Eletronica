#!/usr/bin/env bash
# ==============================================================================
# INICIALIZADOR DOCKER - URNA ELETRÔNICA POKÉMON
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f .env ] && [ -f .env.example ]; then
    echo "Criando arquivo .env a partir de .env.example..."
    cp .env.example .env
fi

echo "=========================================================="
echo "  🚀 INICIANDO AMBIENTE DOCKER (URNA ELETRÔNICA)"
echo "=========================================================="

docker compose up -d --build

echo ""
echo "✔ Containers iniciados com sucesso!"
echo "   👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html"
echo "   👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html"
echo "   👉 API REST Backend: http://localhost:8080/backend/apuracao"
echo "   👉 phpMyAdmin (DB):  http://localhost:8081"
echo ""
echo "Para visualizar os logs: docker compose logs -f"
echo "Para parar os serviços: ./stop.sh"
echo "=========================================================="
