#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Removendo recursos do Kubernetes..."
kubectl delete -k "$SCRIPT_DIR" || true
kubectl delete namespace urna-eletronica || true
echo "Recursos removidos com sucesso."
