#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Parando containers do Podman Compose..."
podman-compose -f podman-compose.yml down
echo "Finalizado com sucesso."
