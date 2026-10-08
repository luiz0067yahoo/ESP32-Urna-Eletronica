#!/usr/bin/env bash
set -e

POD_NAME="urna-pod"

echo "Parando e removendo Podman Pod '$POD_NAME'..."
podman pod rm -f "$POD_NAME" 2>/dev/null || true
echo "Pod finalizado com sucesso."
