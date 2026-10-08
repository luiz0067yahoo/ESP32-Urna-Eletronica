#!/usr/bin/env bash
# ==============================================================================
# POKÉMON ELECTRONIC VOTING MACHINE • MULTI-ENVIRONMENT LAUNCHER (LINUX / MACOS)
# URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO MULTI-AMBIENTE
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
cd "$(dirname "$0")"

# Check CLI argument ($1)
ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
else
  clear
  echo "====================================================================="
  echo "   🗳️ POKÉMON ELECTRONIC VOTING MACHINE / URNA ELETRÔNICA"
  echo "====================================================================="
  echo ""
  echo " Select Language / Selecione o Idioma / Seleccione idioma / Seleziona lingua:"
  echo ""
  echo "  [1] 🇺🇸 English   (Preferential / Default)"
  echo "  [2] 🇧🇷 Português"
  echo "  [3] 🇪🇸 Español"
  echo "  [4] 🇮🇹 Italiano"
  echo ""
  echo "====================================================================="
  read -p "Choice / Escolha [1-4] (Press ENTER for English): " LANG_INPUT

  case "$LANG_INPUT" in
    2) APP_LANG="PT" ;;
    3) APP_LANG="ES" ;;
    4) APP_LANG="IT" ;;
    *) APP_LANG="EN" ;;
  esac
fi

while true; do
  clear
  if [ "$APP_LANG" = "EN" ]; then
    echo "====================================================================="
    echo "   🗳️ POKÉMON ELECTRONIC VOTING MACHINE • ENVIRONMENT LAUNCHER"
    echo "====================================================================="
    echo ""
    echo " Choose the runtime environment:"
    echo ""
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Compose      (Containers via Podman)"
    echo "  [3] ☸️ Kubernetes          (Deploy K8s Manifests / Ingress)"
    echo "  [4] 🐘 Local PHP + MySQL   (PHP Built-in Server / Local Apache)"
    echo "  [5] 🛑 Stop Services       (Stop Docker, Podman, or Local PHP)"
    echo "  [9] 🌐 Change Language     (EN / PT / ES / IT)"
    echo "  [0] ❌ Exit"
    echo ""
    echo "====================================================================="
    read -p "Enter your choice (0-5, 9): " OPCAO
  elif [ "$APP_LANG" = "ES" ]; then
    echo "====================================================================="
    echo "   🗳️ URNA ELECTRÓNICA POKÉMON • CENTRAL DE INICIO"
    echo "====================================================================="
    echo ""
    echo " Elige el entorno en el que deseas ejecutar la aplicación:"
    echo ""
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Compose      (Contenedores vía Podman)"
    echo "  [3] ☸️ Kubernetes          (Despliegue de Manifiestos K8s / Ingress)"
    echo "  [4] 🐘 PHP + MySQL Local   (Servidor Integrado PHP / Apache Local)"
    echo "  [5] 🛑 Detener Servicios   (Apagar Docker, Podman o PHP Local)"
    echo "  [9] 🌐 Cambiar Idioma      (EN / PT / ES / IT)"
    echo "  [0] ❌ Salir"
    echo ""
    echo "====================================================================="
    read -p "Introduce el número de opción (0-5, 9): " OPCAO
  elif [ "$APP_LANG" = "IT" ]; then
    echo "====================================================================="
    echo "   🗳️ URNA ELETTRONICA POKÉMON • CENTRO DI AVVIO"
    echo "====================================================================="
    echo ""
    echo " Scegli l'ambiente in cui desideri eseguire l'applicazione:"
    echo ""
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Compose      (Container tramite Podman)"
    echo "  [3] ☸️ Kubernetes          (Distribuzione Manifesti K8s / Ingress)"
    echo "  [4] 🐘 PHP + MySQL Locale  (Server Integrato PHP / Apache Locale)"
    echo "  [5] 🛑 Ferma Servizi       (Arresta Docker, Podman o PHP Locale)"
    echo "  [9] 🌐 Cambia Lingua       (EN / PT / ES / IT)"
    echo "  [0] ❌ Esci"
    echo ""
    echo "====================================================================="
    read -p "Inserisci il numero dell'opzione (0-5, 9): " OPCAO
  else
    echo "====================================================================="
    echo "   🗳️ URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO"
    echo "====================================================================="
    echo ""
    echo " Escolha o ambiente em que deseja rodar a aplicação:"
    echo ""
    echo "  [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)"
    echo "  [2] 🦭 Podman Compose      (Contêineres via Podman)"
    echo "  [3] ☸️ Kubernetes          (Deploy de Manifestos K8s / Ingress)"
    echo "  [4] 🐘 PHP + MySQL Local   (Servidor Embutido PHP / Apache Local)"
    echo "  [5] 🛑 Parar Serviços      (Derrubar Docker, Podman ou PHP Local)"
    echo "  [9] 🌐 Mudar Idioma        (EN / PT / ES / IT)"
    echo "  [0] ❌ Sair"
    echo ""
    echo "====================================================================="
    read -p "Digite o número da opção (0-5, 9): " OPCAO
  fi

  case "$OPCAO" in
    1)
      echo ""
      echo "====================================================================="
      [ "$APP_LANG" = "EN" ] && echo "  🐳 STARTING DOCKER ENVIRONMENT"
      [ "$APP_LANG" = "ES" ] && echo "  🐳 INICIANDO ENTORNO DOCKER"
      [ "$APP_LANG" = "IT" ] && echo "  🐳 AVVIO AMBIENTE DOCKER"
      [ "$APP_LANG" = "PT" ] && echo "  🐳 INICIANDO AMBIENTE DOCKER"
      echo "====================================================================="
      if ! command -v docker >/dev/null 2>&1; then
        echo "❌ 'docker' command was not found / não foi encontrado."
        read -p "Press Enter / Pressione Enter..."
        continue
      fi

      if ! docker info >/dev/null 2>&1; then
        echo "⚠️ Docker daemon is not running / não está rodando."
        read -p "Press Enter / Pressione Enter..."
        continue
      fi

      if [ ! -f "devops/docker/.env" ] && [ -f "devops/docker/.env.example" ]; then
        cp devops/docker/.env.example devops/docker/.env
      fi

      echo "▶ Starting Docker Compose..."
      docker compose -f devops/docker/docker-compose.yml up -d --build

      echo ""
      echo "✔ Docker environment started / iniciado com sucesso!"
      echo "   👉 Voting Booth: http://localhost:8080/frontend/index.html"
      echo "   👉 Live Results: http://localhost:8080/frontend/apuracao.html"
      echo "   👉 phpMyAdmin:   http://localhost:8081"
      echo ""
      which xdg-open >/dev/null 2>&1 && xdg-open http://localhost:8080/frontend/index.html || true
      read -p "Press Enter to return to menu..."
      ;;

    2)
      echo ""
      echo "====================================================================="
      echo "  🦭 PODMAN ENVIRONMENT"
      echo "====================================================================="
      if ! command -v podman >/dev/null 2>&1; then
        echo "❌ 'podman' command not found."
        read -p "Press Enter..."
        continue
      fi

      if [ ! -f "devops/podman/.env" ] && [ -f "devops/podman/.env.example" ]; then
        cp devops/podman/.env.example devops/podman/.env
      fi

      if command -v podman-compose >/dev/null 2>&1; then
        podman-compose -f devops/podman/podman-compose.yml up -d --build
      else
        podman compose -f devops/podman/podman-compose.yml up -d --build
      fi

      echo ""
      echo "✔ Podman started successfully!"
      read -p "Press Enter to return to menu..."
      ;;

    3)
      echo ""
      echo "====================================================================="
      echo "  ☸️ KUBERNETES CLUSTER DEPLOY"
      echo "====================================================================="
      if ! command -v kubectl >/dev/null 2>&1; then
        echo "❌ 'kubectl' command not found."
        read -p "Press Enter..."
        continue
      fi

      if [ -f "devops/kubernetes/deploy.sh" ]; then
        bash devops/kubernetes/deploy.sh
      fi
      read -p "Press Enter to return to menu..."
      ;;

    4)
      echo ""
      echo "====================================================================="
      echo "  🐘 LOCAL PHP + MYSQL"
      echo "====================================================================="
      if ! command -v php >/dev/null 2>&1; then
        echo "⚠️ 'php' command not found in PATH."
        read -p "Press Enter..."
        continue
      fi

      echo "1. Checking/migrating database via PHP..."
      php db/install.php

      echo ""
      echo "2. Starting PHP Built-in Server on port 8080..."
      php -S localhost:8080 >/dev/null 2>&1 &
      PHP_PID=$!
      echo "PHP Server PID: $PHP_PID"

      sleep 2
      echo ""
      echo "✔ Local PHP Server running at http://localhost:8080!"
      echo "   👉 Voting Booth: http://localhost:8080/frontend/index.html"
      echo "   👉 Live Results: http://localhost:8080/frontend/apuracao.html"
      echo ""
      which xdg-open >/dev/null 2>&1 && xdg-open http://localhost:8080/frontend/index.html || open http://localhost:8080/frontend/index.html 2>/dev/null || true
      read -p "Press Enter to return to menu..."
      ;;

    5)
      echo ""
      echo "====================================================================="
      echo "  🛑 STOPPING ALL SERVICES"
      echo "====================================================================="
      command -v docker >/dev/null 2>&1 && docker compose -f devops/docker/docker-compose.yml down 2>/dev/null || true
      command -v podman >/dev/null 2>&1 && podman compose -f devops/podman/podman-compose.yml down 2>/dev/null || true
      pkill -f "php -S localhost:8080" 2>/dev/null || true
      echo "✔ Services stopped."
      read -p "Press Enter to return to menu..."
      ;;

    9)
      clear
      echo "====================================================================="
      echo " Select Language / Selecione o Idioma / Seleccione / Seleziona:"
      echo "  [1] 🇺🇸 English (Default)"
      echo "  [2] 🇧🇷 Português"
      echo "  [3] 🇪🇸 Español"
      echo "  [4] 🇮🇹 Italiano"
      echo "====================================================================="
      read -p "Choice [1-4]: " NEW_LANG
      case "$NEW_LANG" in
        2) APP_LANG="PT" ;;
        3) APP_LANG="ES" ;;
        4) APP_LANG="IT" ;;
        *) APP_LANG="EN" ;;
      esac
      ;;

    0)
      echo "Exiting / Saindo..."
      exit 0
      ;;

    *)
      echo "Invalid option / Opção inválida."
      sleep 1
      ;;
  esac
done
