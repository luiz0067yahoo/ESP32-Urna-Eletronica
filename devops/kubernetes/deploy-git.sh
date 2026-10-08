#!/usr/bin/env bash
# ==============================================================================
# DEPLOY AUTOMÁTICO VIA GIT - KUBERNETES
# Atualiza código, reconstrói imagem se necessário e aplica manifestos
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BRANCH="${1:-main}"

echo "=========================================================="
echo "  ☸️ DEPLOY AUTOMÁTICO VIA GIT (KUBERNETES) - BRANCH: $BRANCH"
echo "=========================================================="

cd "$PROJECT_ROOT"

# 1. Puxa as alterações do repositório Git
echo "1. Atualizando código do repositório Git..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

# Obtém a hash do commit para rastreabilidade
COMMIT_SHA=$(git rev-parse --short HEAD)
echo "   -> Commit atual: $COMMIT_SHA"

# 2. Constrói a nova imagem com tag do commit e tag latest
echo "2. Construindo imagem Docker urna-app:$COMMIT_SHA..."
docker build -t "urna-app:$COMMIT_SHA" -t urna-app:latest -f "$SCRIPT_DIR/../docker/Dockerfile" "$PROJECT_ROOT"

# Se estiver no Minikube ou Kind, carrega a nova imagem
if command -v minikube >/dev/null 2>&1 && minikube status >/dev/null 2>&1; then
    echo "   -> Carregando nova imagem no Minikube..."
    minikube image load "urna-app:$COMMIT_SHA"
    minikube image load urna-app:latest
elif command -v kind >/dev/null 2>&1 && kind get clusters >/dev/null 2>&1; then
    CLUSTER_NAME=$(kind get clusters | head -n 1)
    if [ -n "$CLUSTER_NAME" ]; then
        echo "   -> Carregando nova imagem no cluster Kind '$CLUSTER_NAME'..."
        kind load docker-image "urna-app:$COMMIT_SHA" --name "$CLUSTER_NAME"
        kind load docker-image urna-app:latest --name "$CLUSTER_NAME"
    fi
fi

# 3. Aplica os manifestos Kustomize
echo "3. Aplicando manifestos no cluster Kubernetes..."
kubectl apply -k "$SCRIPT_DIR"

# 4. Força reinicialização do Deployment para carregar a nova versão
echo "4. Atualizando pods com a nova versão..."
kubectl rollout restart deployment/urna-app -n urna-eletronica

# 5. Aguarda conclusão do rollout
echo "5. Aguardando novo rollout concluir..."
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo ""
echo "✔ Deploy automático via Git finalizado com sucesso no Kubernetes!"
kubectl get pods -n urna-eletronica
echo "=========================================================="
