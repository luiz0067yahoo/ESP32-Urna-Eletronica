#!/usr/bin/env bash
# ==============================================================================
# EXECUTOR DA SUÍTE DE TESTES E SIMULADORES (LINUX / MACOS)
# Urna Eletrônica Pokémon • POKE
# ==============================================================================

set -e
cd "$(dirname "$0")"

echo "====================================================================="
echo "   🧪 PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON"
echo "====================================================================="
echo ""
echo "Escolha o teste ou simulador que deseja executar:"
echo " [1] 🧪 Executar Bateria Completa de Testes de Sistema (API REST)"
echo " [2] 🤖 Executar Simulador do Terminal Eleitoral POKE (Votação Unitária)"
echo " [3] ⚡ Executar Simulador de Eleição em Massa (Teste de Carga / 50 Eleitores)"
echo " [4] ⌨️ Executar Simulador do Teclado Virtual & Validador de Votos"
echo " [5] 🌐 Abrir Dashboard Visual de Testes no Navegador (tests/index.html)"
echo " [0] Sair"
echo ""

read -p "Digite o número da opção (0-5): " OPCAO

case "$OPCAO" in
  1)
    echo -e "\n▶ Executando testes automatizados de sistema..."
    php test_sistema_api.php "$@"
    ;;
  2)
    echo -e "\n▶ Executando simulador de terminal eleitoral..."
    php simulador_poke.php "$@"
    ;;
  3)
    echo -e "\n▶ Executando simulador de carga e estresse..."
    php simulador_eleicao_massa.php 50 10 "$@"
    ;;
  4)
    echo -e "\n▶ Executando simulador de teclado virtual e validador de votos..."
    php simulador_teclado_matricial.php
    ;;
  5)
    echo -e "\n▶ Abrindo Dashboard Visual..."
    xdg-open index.html 2>/dev/null || open index.html 2>/dev/null || echo "Abra tests/index.html no seu navegador."
    ;;
  *)
    echo "Saindo..."
    exit 0
    ;;
esac
