#!/usr/bin/env bash
# ==============================================================================
# DEVOPS UNIFIED LAUNCHER (LINUX / MACOS) - POKÉMON ELECTRONIC VOTING MACHINE
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  clear
  echo "=========================================================="
  echo "  🛠️ DEVOPS UNIFIED LAUNCHER • POKÉMON BALLOT BOX"
  echo "=========================================================="
  echo " Select Language / Selecione o Idioma / Seleccione / Seleziona:"
  echo "  [1] 🇺🇸 English (Default)"
  echo "  [2] 🇧🇷 Português"
  echo "  [3] 🇪🇸 Español"
  echo "  [4] 🇮🇹 Italiano"
  echo "=========================================================="
  read -p "Choice [1-4] (Press ENTER for English): " LANG_CHOICE
  case "$LANG_CHOICE" in
    2) APP_LANG="PT" ;;
    3) APP_LANG="ES" ;;
    4) APP_LANG="IT" ;;
    *) APP_LANG="EN" ;;
  esac
fi

while true; do
  clear
  echo "=========================================================="
  if [ "$APP_LANG" = "EN" ]; then
    echo "  🛠️ DEVOPS CONTROL PANEL - POKÉMON BALLOT BOX"
    echo "=========================================================="
    echo ""
    echo " Choose the DevOps environment to start:"
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Pod          (Native Rootless Podman Pod)"
    echo "  [3] 🦭 Podman Compose      (Podman Compose stack)"
    echo "  [4] ☸️ Kubernetes          (Deploy manifests with Kustomize)"
    echo "  [5] ⚙️ Native Host         (PHP Built-in Server / Local MySQL)"
    echo "  [6] 🛑 Stop Docker"
    echo "  [7] 🛑 Stop Podman"
    echo "  [8] 🛑 Destroy Kubernetes Deployment"
    echo "  [9] 🌐 Change Language (EN / PT / ES / IT)"
    echo "  [0] ❌ Exit"
    echo "=========================================================="
    read -p "Enter choice (0-9): " OPCAO
  elif [ "$APP_LANG" = "ES" ]; then
    echo "  🛠️ PANEL DE CONTROL DEVOPS - URNA ELECTRÓNICA"
    echo "=========================================================="
    echo ""
    echo " Elige el entorno DevOps para iniciar:"
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Pod          (Pod Nativo de Podman)"
    echo "  [3] 🦭 Podman Compose      (Pila de Podman Compose)"
    echo "  [4] ☸️ Kubernetes          (Despliegue con Kustomize)"
    echo "  [5] ⚙️ Host Nativo         (Servidor PHP Integrado / MySQL Local)"
    echo "  [6] 🛑 Detener Docker"
    echo "  [7] 🛑 Detener Podman"
    echo "  [8] 🛑 Eliminar Despliegue Kubernetes"
    echo "  [9] 🌐 Cambiar Idioma (EN / PT / ES / IT)"
    echo "  [0] ❌ Salir"
    echo "=========================================================="
    read -p "Introduce opción (0-9): " OPCAO
  elif [ "$APP_LANG" = "IT" ]; then
    echo "  🛠️ PANNELLO DI CONTROLLO DEVOPS - URNA ELETTRONICA"
    echo "=========================================================="
    echo ""
    echo " Scegli l'ambiente DevOps da avviare:"
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Pod          (Pod Nativo Podman)"
    echo "  [3] 🦭 Podman Compose      (Stack Podman Compose)"
    echo "  [4] ☸️ Kubernetes          (Distribuzione con Kustomize)"
    echo "  [5] ⚙️ Host Nativo         (Server PHP Integrato / MySQL Locale)"
    echo "  [6] 🛑 Arresta Docker"
    echo "  [7] 🛑 Arresta Podman"
    echo "  [8] 🛑 Rimuovi Distribuzione Kubernetes"
    echo "  [9] 🌐 Cambia Lingua (EN / PT / ES / IT)"
    echo "  [0] ❌ Esci"
    echo "=========================================================="
    read -p "Inserisci opzione (0-9): " OPCAO
  else
    echo "  🛠️ PAINEL DE CONTROLE DEVOPS - URNA ELETRÔNICA"
    echo "=========================================================="
    echo ""
    echo " Escolha o ambiente DevOps para inicializar:"
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Pod          (Pod Nativo do Podman)"
    echo "  [3] 🦭 Podman Compose      (Stack Podman Compose)"
    echo "  [4] ☸️ Kubernetes          (Deploy de Manifestos com Kustomize)"
    echo "  [5] ⚙️ Host Nativo         (Servidor PHP Embutido / MySQL Local)"
    echo "  [6] 🛑 Parar Docker"
    echo "  [7] 🛑 Parar Podman"
    echo "  [8] 🛑 Remover Deploy Kubernetes"
    echo "  [9] 🌐 Mudar Idioma (EN / PT / ES / IT)"
    echo "  [0] ❌ Sair"
    echo "=========================================================="
    read -p "Digite a opção (0-9): " OPCAO
  fi

  case "$OPCAO" in
    1) bash docker/start.sh "$APP_LANG" ;;
    2) bash podman/start-pod.sh "$APP_LANG" ;;
    3) bash podman/start-compose.sh "$APP_LANG" ;;
    4) bash kubernetes/deploy.sh "$APP_LANG" ;;
    5) bash config/start.sh "$APP_LANG" ;;
    6) bash docker/stop.sh "$APP_LANG" ;;
    7) bash podman/stop-pod.sh "$APP_LANG" ;;
    8) bash kubernetes/destroy.sh "$APP_LANG" ;;
    9)
      echo "Select Language: [1] EN, [2] PT, [3] ES, [4] IT"
      read -p "Choice [1-4]: " NEW_LANG
      case "$NEW_LANG" in
        2) APP_LANG="PT" ;;
        3) APP_LANG="ES" ;;
        4) APP_LANG="IT" ;;
        *) APP_LANG="EN" ;;
      esac
      ;;
    0) exit 0 ;;
    *) echo "Invalid option." ; sleep 1 ;;
  esac
done
