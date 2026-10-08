#!/usr/bin/env bash
# Gera manifesto Kubernetes a partir do Podman Pod em execução
set -e

POD_NAME="urna-pod"
OUTPUT_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/podman-kube-exported.yaml"

if ! podman pod exists "$POD_NAME" 2>/dev/null; then
    echo "❌ O Pod '$POD_NAME' precisa estar em execução para gerar o manifesto."
    echo "Execute primeiro: ./start-pod.sh"
    exit 1
fi

echo "Exportando Podman Pod '$POD_NAME' para manifesto Kubernetes YAML..."
podman generate kube "$POD_NAME" > "$OUTPUT_FILE"

echo "✔ Manifesto gerado em: $OUTPUT_FILE"
echo "Você pode executá-lo em qualquer cluster Kubernetes via: kubectl apply -f $OUTPUT_FILE"
