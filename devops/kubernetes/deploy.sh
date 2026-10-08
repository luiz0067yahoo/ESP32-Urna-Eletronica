#!/usr/bin/env bash
# ==============================================================================
# DEPLOY KUBERNETES - URNA ELETRÔNICA POKÉMON
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=========================================================="
echo "  ☸️ DEPLOY KUBERNETES - URNA ELETRÔNICA POKÉMON"
echo "=========================================================="

if ! command -v kubectl >/dev/null 2>&1; then
    echo "❌ Erro: 'kubectl' não está instalado ou não foi encontrado no PATH."
    exit 1
fi

# 1. Constrói a imagem Docker local caso não exista
if ! docker image inspect urna-app:latest >/dev/null 2>&1; then
    echo "1. Imagem 'urna-app:latest' não encontrada. Construindo localmente..."
    docker build -t urna-app:latest -f "$PROJECT_ROOT/devops/docker/Dockerfile" "$PROJECT_ROOT"
else
    echo "1. Imagem 'urna-app:latest' já existe localmente."
fi

# Se estiver usando Minikube ou Kind, carrega a imagem no nó
if command -v minikube >/dev/null 2>&1 && minikube status >/dev/null 2>&1; then
    echo "   -> Minikube detectado! Carregando imagem no cluster Minikube..."
    minikube image load urna-app:latest || true
elif command -v kind >/dev/null 2>&1 && kind get clusters >/dev/null 2>&1; then
    CLUSTER_NAME=$(kind get clusters | head -n 1)
    if [ -n "$CLUSTER_NAME" ]; then
        echo "   -> Kind detectado! Carregando imagem no cluster '$CLUSTER_NAME'..."
        kind load docker-image urna-app:latest --name "$CLUSTER_NAME" || true
    fi
fi

# 2. Aplica manifestos usando Kustomize
echo "2. Aplicando manifestos Kubernetes..."
kubectl apply -k "$SCRIPT_DIR"

# 3. Aguarda disponibilidade do banco de dados e da aplicação
echo "3. Aguardando inicialização do banco de dados (Deployment: urna-db)..."
kubectl rollout status deployment/urna-db -n urna-eletronica --timeout=120s

echo "4. Aguardando pods da aplicação ficarem prontos (Deployment: urna-app)..."
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo ""
echo "✔ Deploy realizado com sucesso no namespace 'urna-eletronica'!"
echo ""
echo "📋 Informações de Acesso:"
echo "   Opção 1: Via NodePort (porta 30080):"
echo "      http://localhost:30080/frontend/index.html"
echo ""
echo "   Opção 2: Via Port-Forward local:"
echo "      kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica"
echo "      Em seguida acesse: http://localhost:8080/frontend/index.html"
echo ""
echo "   Opção 3 (Minikube):"
echo "      minikube service urna-app-service -n urna-eletronica"
echo ""
echo "Para verificar os pods: kubectl get pods -n urna-eletronica"
echo "Para desinstalar: ./destroy.sh"
echo "=========================================================="
