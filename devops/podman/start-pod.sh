#!/usr/bin/env bash
# ==============================================================================
# INICIALIZAÇÃO NATIVA DE POD COM PODMAN (SEM COMPOSE)
# Cria um Pod compartilhado estilo Kubernetes no Podman
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

POD_NAME="urna-pod"
APP_IMAGE="urna-app:podman"

echo "=========================================================="
echo "  🚀 INICIANDO POD NATIVO PODMAN ($POD_NAME)"
echo "=========================================================="

# 1. Remove pod anterior se existir
if podman pod exists "$POD_NAME" 2>/dev/null; then
    echo "Removendo pod anterior..."
    podman pod rm -f "$POD_NAME" || true
fi

# 2. Cria o Pod compartilhando a porta 8080 na rede interna do Pod
echo "1. Criando Pod '$POD_NAME' com porta 8080 exposta..."
podman pod create --name "$POD_NAME" -p 8080:80

# 3. Inicia o banco de dados dentro do Pod (compartilha localhost com o App)
echo "2. Subindo container do banco (MariaDB) no Pod..."
podman run -d \
    --name urna-db \
    --pod "$POD_NAME" \
    --restart unless-stopped \
    -e MYSQL_DATABASE=urna \
    -e MYSQL_USER=urna \
    -e MYSQL_PASSWORD=urna123 \
    -e MYSQL_ROOT_PASSWORD=rootpassword \
    -v urna_pod_db_data:/var/lib/mysql:Z \
    docker.io/library/mariadb:10.11

# 4. Constrói a imagem da aplicação
echo "3. Construindo imagem da aplicação ($APP_IMAGE)..."
podman build -t "$APP_IMAGE" -f "$SCRIPT_DIR/Containerfile" "$PROJECT_ROOT"

# 5. Inicia o container da aplicação no mesmo Pod
# Como compartilham o Pod, DB_HOST pode ser 127.0.0.1 (localhost)!
echo "4. Subindo aplicação Urna no Pod..."
podman run -d \
    --name urna-app \
    --pod "$POD_NAME" \
    --restart unless-stopped \
    -e DB_HOST=127.0.0.1 \
    -e DB_PORT=3306 \
    -e DB_NAME=urna \
    -e DB_USER=urna \
    -e DB_PASS=urna123 \
    "$APP_IMAGE"

echo ""
echo "✔ Podman Pod '$POD_NAME' iniciado com sucesso!"
echo "   👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html"
echo "   👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html"
echo "   👉 API REST Backend: http://localhost:8080/backend/apuracao"
echo ""
echo "Para verificar status: podman pod ps"
echo "Para parar e remover: ./stop-pod.sh"
echo "=========================================================="
