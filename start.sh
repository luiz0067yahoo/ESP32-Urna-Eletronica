#!/usr/bin/env bash
# ==============================================================================
# URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO MULTI-AMBIENTE (LINUX/MACOS)
# Permite escolher entre Docker, Podman, Kubernetes ou PHP/MySQL Local
# ==============================================================================

set -e
cd "$(dirname "$0")"

while true; do
  clear
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
  echo "  [0] ❌ Sair"
  echo ""
  echo "====================================================================="
  read -p "Digite o número da opção (0-5): " OPCAO

  case "$OPCAO" in
    1)
      echo ""
      echo "====================================================================="
      echo "  🐳 INICIANDO AMBIENTE DOCKER"
      echo "====================================================================="
      if ! command -v docker >/dev/null 2>&1; then
        echo "❌ [ERRO] O comando 'docker' não foi encontrado."
        echo "👉 Instale o Docker: https://docs.docker.com/get-docker/"
        echo "👉 Ou utilize a opção [4] para executar com PHP + MySQL Local."
        read -p "Pressione Enter para voltar ao menu..."
        continue
      fi

      if ! docker info >/dev/null 2>&1; then
        echo "⚠️ [AVISO] O daemon do Docker não está rodando. Inicie o serviço Docker."
        read -p "Pressione Enter para voltar ao menu..."
        continue
      fi

      if [ ! -f "devops/docker/.env" ] && [ -f "devops/docker/.env.example" ]; then
        cp devops/docker/.env.example devops/docker/.env
      fi

      echo "▶ Subindo contêineres com Docker Compose..."
      docker compose -f devops/docker/docker-compose.yml up -d --build

      echo ""
      echo "✔ Ambiente Docker iniciado com sucesso!"
      echo "   👉 Cabine de Votação: http://localhost:8080/frontend/index.html"
      echo "   👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html"
      echo "   👉 phpMyAdmin:        http://localhost:8081"
      echo ""
      read -p "Pressione Enter para continuar..."
      ;;

    2)
      echo ""
      echo "====================================================================="
      echo "  🦭 INICIANDO AMBIENTE PODMAN"
      echo "====================================================================="
      if ! command -v podman >/dev/null 2>&1; then
        echo "❌ [ERRO] O comando 'podman' não foi encontrado."
        echo "👉 Instale o Podman: https://podman.io/"
        read -p "Pressione Enter para voltar ao menu..."
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
      echo "✔ Ambiente Podman iniciado com sucesso!"
      echo "   👉 Cabine de Votação: http://localhost:8080/frontend/index.html"
      echo "   👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html"
      echo ""
      read -p "Pressione Enter para continuar..."
      ;;

    3)
      echo ""
      echo "====================================================================="
      echo "  ☸️ DEPLOY EM CLUSTER KUBERNETES"
      echo "====================================================================="
      if ! command -v kubectl >/dev/null 2>&1; then
        echo "❌ [ERRO] O comando 'kubectl' não foi encontrado."
        read -p "Pressione Enter para voltar ao menu..."
        continue
      fi

      bash devops/kubernetes/deploy.sh
      read -p "Pressione Enter para continuar..."
      ;;

    4)
      echo ""
      echo "====================================================================="
      echo "  🐘 INICIANDO COM PHP + MYSQL LOCAL"
      echo "====================================================================="
      if ! command -v php >/dev/null 2>&1; then
        echo "❌ [ERRO] O comando 'php' não foi encontrado no PATH."
        echo "👉 Instale o PHP CLI ou utilize XAMPP / LAMP Server."
        read -p "Pressione Enter para voltar ao menu..."
        continue
      fi

      echo "1. Verificando e instalando banco de dados MySQL via PHP..."
      php db/install.php || true

      echo ""
      echo "2. Iniciando Servidor Embutido do PHP na porta 8080..."
      echo "   👉 Pressione Ctrl+C para encerrar o servidor quando desejar."
      echo ""
      echo "   ✔ Urna Eletrônica:  http://localhost:8080/frontend/index.html"
      echo "   ✔ Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html"
      echo ""

      xdg-open "http://localhost:8080/frontend/index.html" 2>/dev/null || open "http://localhost:8080/frontend/index.html" 2>/dev/null || true
      php -S localhost:8080
      ;;

    5)
      echo ""
      echo "====================================================================="
      echo "  🛑 PARANDO TODOS OS SERVIÇOS EM EXECUÇÃO"
      echo "====================================================================="
      if command -v docker >/dev/null 2>&1; then
        echo "▶ Parando Docker Compose..."
        docker compose -f devops/docker/docker-compose.yml down 2>/dev/null || true
      fi

      if command -v podman >/dev/null 2>&1; then
        echo "▶ Parando Podman Compose..."
        podman compose -f devops/podman/podman-compose.yml down 2>/dev/null || true
      fi

      echo "▶ Encerrando processos PHP embutidos locais na porta 8080..."
      pkill -f "php -S localhost:8080" 2>/dev/null || true

      echo ""
      echo "✔ Todos os serviços foram encerrados!"
      read -p "Pressione Enter para continuar..."
      ;;

    0)
      echo ""
      echo "Saindo da Central de Inicialização..."
      exit 0
      ;;

    *)
      echo "Opção inválida."
      sleep 1
      ;;
  esac
done
