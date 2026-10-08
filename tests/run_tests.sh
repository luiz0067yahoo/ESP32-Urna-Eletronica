#!/usr/bin/env bash
# ==============================================================================
# TEST SUITE & SIMULATORS RUNNER (LINUX / MACOS)
# PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON
# Supports 4 Languages: English (Default), Português, Español, Italiano
# ==============================================================================

set -e
cd "$(dirname "$0")"

ARG_LANG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
if [[ "$ARG_LANG" == "EN" || "$ARG_LANG" == "PT" || "$ARG_LANG" == "ES" || "$ARG_LANG" == "IT" ]]; then
  APP_LANG="$ARG_LANG"
  shift || true
else
  clear
  echo "====================================================================="
  echo "   🧪 POKÉMON BALLOT BOX • TEST SUITE & SIMULATORS"
  echo "====================================================================="
  echo ""
  echo " Select Language / Selecione o Idioma / Seleccione / Seleziona:"
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
    echo "   🧪 TEST SUITE & SIMULATORS • POKÉMON ELECTRONIC VOTING MACHINE"
    echo "====================================================================="
    echo ""
    echo " Choose the test or simulator to run:"
    echo "  [1] 🧪 Automated API Contract Test Suite (12 tests)"
    echo "  [2] 🤖 Voting Terminal Simulator (Single voter flow)"
    echo "  [3] ⚡ Mass Election Stress Simulator (50 voters / load test)"
    echo "  [4] ⌨️ Virtual Keypad & Ballot Digit Validator"
    echo "  [5] 🌐 Open Visual Dashboard in Browser (tests/index.html)"
    echo "  [9] 🌐 Change Language (EN / PT / ES / IT)"
    echo "  [0] ❌ Exit"
    echo ""
    echo "====================================================================="
    read -p "Enter your choice (0-5, 9): " OPCAO
  elif [ "$APP_LANG" = "ES" ]; then
    echo "====================================================================="
    echo "   🧪 PANEL DE PRUEBAS Y SIMULADORES • URNA ELECTRÓNICA POKÉMON"
    echo "====================================================================="
    echo ""
    echo " Elige la prueba o simulador que deseas ejecutar:"
    echo "  [1] 🧪 Batería Completa de Pruebas de API REST (12 pruebas)"
    echo "  [2] 🤖 Simulador del Terminal Electoral POKE (Votación Unitaria)"
    echo "  [3] ⚡ Simulador de Elección Masiva (Prueba de Carga / 50 Votantes)"
    echo "  [4] ⌨️ Simulador de Teclado Virtual y Validador de Votos"
    echo "  [5] 🌐 Abrir Panel Visual de Pruebas en Navegador (tests/index.html)"
    echo "  [9] 🌐 Cambiar Idioma (EN / PT / ES / IT)"
    echo "  [0] ❌ Salir"
    echo ""
    echo "====================================================================="
    read -p "Introduce el número de opción (0-5, 9): " OPCAO
  elif [ "$APP_LANG" = "IT" ]; then
    echo "====================================================================="
    echo "   🧪 PANNELLO DI TEST E SIMULATORI • URNA ELETTRONICA POKÉMON"
    echo "====================================================================="
    echo ""
    echo " Scegli il test o simulatore da eseguire:"
    echo "  [1] 🧪 Suite Completa di Test di Sistema (API REST - 12 test)"
    echo "  [2] 🤖 Simulatore del Terminale Elettorale POKE (Voto Singolo)"
    echo "  [3] ⚡ Simulatore di Elezione di Massa (Test di Carico / 50 Elettori)"
    echo "  [4] ⌨️ Simulatore Tastierino Virtuale e Validatore Voti"
    echo "  [5] 🌐 Apri Cruscotto Visivo nel Browser (tests/index.html)"
    echo "  [9] 🌐 Cambia Lingua (EN / PT / ES / IT)"
    echo "  [0] ❌ Esci"
    echo ""
    echo "====================================================================="
    read -p "Inserisci il numero dell'opzione (0-5, 9): " OPCAO
  else
    echo "====================================================================="
    echo "   🧪 PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON"
    echo "====================================================================="
    echo ""
    echo " Escolha o teste ou simulador que deseja executar:"
    echo "  [1] 🧪 Executar Bateria Completa de Testes de Sistema (API REST)"
    echo "  [2] 🤖 Executar Simulador do Terminal Eleitoral POKE (Votação Unitária)"
    echo "  [3] ⚡ Executar Simulador de Eleição em Massa (Teste de Carga / 50 Eleitores)"
    echo "  [4] ⌨️ Executar Simulador do Teclado Virtual & Validador de Votos"
    echo "  [5] 🌐 Abrir Dashboard Visual de Testes no Navegador (tests/index.html)"
    echo "  [9] 🌐 Mudar Idioma (EN / PT / ES / IT)"
    echo "  [0] ❌ Sair"
    echo ""
    echo "====================================================================="
    read -p "Digite o número da opção (0-5, 9): " OPCAO
  fi

  case "$OPCAO" in
    1)
      echo -e "\n▶ Running automated system API tests..."
      php test_sistema_api.php "$@"
      read -p "Press Enter to continue..."
      ;;
    2)
      echo -e "\n▶ Running voting terminal simulator..."
      php simulador_poke.php "$@"
      read -p "Press Enter to continue..."
      ;;
    3)
      echo -e "\n▶ Running mass load & stress simulator..."
      php simulador_eleicao_massa.php 50 10 "$@"
      read -p "Press Enter to continue..."
      ;;
    4)
      echo -e "\n▶ Running keypad simulator & validator..."
      php simulador_teclado_matricial.php
      read -p "Press Enter to continue..."
      ;;
    5)
      echo -e "\n▶ Opening Visual Dashboard..."
      xdg-open index.html 2>/dev/null || open index.html 2>/dev/null || echo "Open tests/index.html in your browser."
      read -p "Press Enter to continue..."
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
