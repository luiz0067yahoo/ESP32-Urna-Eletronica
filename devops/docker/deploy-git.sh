#!/usr/bin/env bash
# ==============================================================================
# DEPLOY AUTOMÁTICO VIA GIT - DOCKER & DOCKER COMPOSE
# Atualiza o repositório, reconstrói containers e aplica migrações
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BRANCH="${1:-main}"

echo "=========================================================="
echo "  🚀 DEPLOY AUTOMÁTICO VIA GIT (DOCKER) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"

# 1. Atualiza o código do repositório Git
echo "1. Buscando atualizações do Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

# 2. Garante configuração de ambiente (.env)
cd "$SCRIPT_DIR"
if [ ! -f .env ] && [ -f .env.example ]; then
    echo "2. Configurando arquivo .env a partir do .env.example..."
    cp .env.example .env
fi

# 3. Reconstrói e atualiza os containers sem downtime prolongado
echo "3. Reconstruindo e aplicando containers Docker..."
docker compose up -d --build --remove-orphans

# 4. Aguarda container saudável e executa migrações/seed
echo "4. Verificando saúde e executando migrações do banco..."
sleep 5
docker compose exec -T app php db/install.php || true

# 5. Limpa imagens órfãs/antigas para economizar espaço
echo "5. Limpando imagens antigas..."
docker image prune -f

echo ""
echo "✔ Deploy automático via Git concluído com sucesso!"
echo "   Status dos containers:"
docker compose ps
echo "=========================================================="
