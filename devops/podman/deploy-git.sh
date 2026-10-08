#!/usr/bin/env bash
# ==============================================================================
# DEPLOY AUTOMÁTICO VIA GIT - PODMAN (ROOTLESS / DAEMONLESS)
# Atualiza repositório, reconstrói imagens e atualiza serviços
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BRANCH="${1:-main}"

echo "=========================================================="
echo "  🚀 DEPLOY AUTOMÁTICO VIA GIT (PODMAN) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"

# 1. Atualiza repositório Git
echo "1. Puxando alterações do Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

# 2. Configura variáveis de ambiente
cd "$SCRIPT_DIR"
if [ ! -f .env ] && [ -f .env.example ]; then
    echo "2. Criando .env a partir de .env.example..."
    cp .env.example .env
fi

# 3. Atualização
if command -v podman-compose >/dev/null 2>&1; then
    echo "3. Atualizando com Podman Compose..."
    podman-compose -f podman-compose.yml up -d --build
    sleep 5
    podman exec urna_podman_app php db/install.php || true
else
    echo "3. Atualizando via Pod Nativo Podman..."
    chmod +x start-pod.sh
    ./start-pod.sh
    sleep 5
    podman exec urna-app php db/install.php || true
fi

# 4. Limpeza de imagens intermediárias
echo "4. Limpando imagens antigas..."
podman image prune -f || true

echo ""
echo "✔ Deploy automático Podman via Git finalizado!"
echo "=========================================================="
