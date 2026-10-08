@echo off
REM ==============================================================================
REM TEST SUITE & SIMULATORS RUNNER (WINDOWS)
REM PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Check if language was passed as argument (%1)
if /i "%~1"=="en" (set APP_LANG=EN& shift& goto DETECT_PHP)
if /i "%~1"=="pt" (set APP_LANG=PT& shift& goto DETECT_PHP)
if /i "%~1"=="es" (set APP_LANG=ES& shift& goto DETECT_PHP)
if /i "%~1"=="it" (set APP_LANG=IT& shift& goto DETECT_PHP)

:LANG_SELECT
cls
echo =====================================================================
echo    🧪 POKÉMON BALLOT BOX • TEST SUITE & SIMULATORS
echo =====================================================================
echo.
echo  Select Language / Selecione o Idioma / Seleccione idioma / Seleziona lingua:
echo.
echo   [1] 🇺🇸 English   (Preferential / Default)
echo   [2] 🇧🇷 Português
echo   [3] 🇪🇸 Español
echo   [4] 🇮🇹 Italiano
echo.
echo =====================================================================
set /p LANG_INPUT="Choice / Escolha [1-4] (Press ENTER for English): "

if "%LANG_INPUT%"=="" set LANG_INPUT=1
if "%LANG_INPUT%"=="1" set APP_LANG=EN
if "%LANG_INPUT%"=="2" set APP_LANG=PT
if "%LANG_INPUT%"=="3" set APP_LANG=ES
if "%LANG_INPUT%"=="4" set APP_LANG=IT
if not defined APP_LANG set APP_LANG=EN

:DETECT_PHP
set PHP_BIN=php
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\xampp\php\php.exe" (
        set PHP_BIN=C:\xampp\php\php.exe
    ) else if exist "C:\laragon\bin\php\php.exe" (
        set PHP_BIN=C:\laragon\bin\php\php.exe
    )
)

:MENU
cls
if "%APP_LANG%"=="EN" (
    echo =====================================================================
    echo    🧪 TEST SUITE & SIMULATORS • POKÉMON ELECTRONIC VOTING MACHINE
    echo =====================================================================
    echo.
    echo  Choose the test or simulator to run:
    echo.
    echo   [1] 🧪 Automated API Contract Test Suite (12 tests)
    echo   [2] 🤖 Voting Terminal Simulator (Single voter flow)
    echo   [3] ⚡ Mass Election Stress Simulator (50 voters / load test)
    echo   [4] ⌨️ Virtual Keypad & Ballot Digit Validator
    echo   [5] 🌐 Open Visual Dashboard in Browser (tests/index.html)
    echo   [9] 🌐 Change Language (EN / PT / ES / IT)
    echo   [0] ❌ Exit
    echo.
    echo =====================================================================
    set /p OPCAO="Enter your choice (0-5, 9): "
) else if "%APP_LANG%"=="ES" (
    echo =====================================================================
    echo    🧪 PANEL DE PRUEBAS Y SIMULADORES • URNA ELECTRÓNICA POKÉMON
    echo =====================================================================
    echo.
    echo  Elige la prueba o simulador que deseas ejecutar:
    echo.
    echo   [1] 🧪 Batería Completa de Pruebas de API REST (12 pruebas)
    echo   [2] 🤖 Simulador del Terminal Electoral POKE (Votación Unitaria)
    echo   [3] ⚡ Simulador de Elección Masiva (Prueba de Carga / 50 Votantes)
    echo   [4] ⌨️ Simulador de Teclado Virtual y Validador de Votos
    echo   [5] 🌐 Abrir Panel Visual de Pruebas en Navegador (tests/index.html)
    echo   [9] 🌐 Cambiar Idioma (EN / PT / ES / IT)
    echo   [0] ❌ Salir
    echo.
    echo =====================================================================
    set /p OPCAO="Introduce el número de opción (0-5, 9): "
) else if "%APP_LANG%"=="IT" (
    echo =====================================================================
    echo    🧪 PANNELLO DI TEST E SIMULATORI • URNA ELETTRONICA POKÉMON
    echo =====================================================================
    echo.
    echo  Scegli il test o simulatore da eseguire:
    echo.
    echo   [1] 🧪 Suite Completa di Test di Sistema (API REST - 12 test)
    echo   [2] 🤖 Simulatore del Terminale Elettorale POKE (Voto Singolo)
    echo   [3] ⚡ Simulatore di Elezione di Massa (Test di Carico / 50 Elettori)
    echo   [4] ⌨️ Simulatore Tastierino Virtuale e Validatore Voti
    echo   [5] 🌐 Apri Cruscotto Visivo nel Browser (tests/index.html)
    echo   [9] 🌐 Cambia Lingua (EN / PT / ES / IT)
    echo   [0] ❌ Esci
    echo.
    echo =====================================================================
    set /p OPCAO="Inserisci il numero dell'opzione (0-5, 9): "
) else (
    echo =====================================================================
    echo    🧪 PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON
    echo =====================================================================
    echo.
    echo  Escolha o teste ou simulador que deseja executar:
    echo.
    echo   [1] 🧪 Executar Bateria Completa de Testes de Sistema (API REST)
    echo   [2] 🤖 Executar Simulador do Terminal Eleitoral POKE (Votação Unitária)
    echo   [3] ⚡ Executar Simulador de Eleição em Massa (Teste de Carga / 50 Eleitores)
    echo   [4] ⌨️ Executar Simulador do Teclado Virtual & Validador de Votos
    echo   [5] 🌐 Abrir Dashboard Visual de Testes no Navegador (tests/index.html)
    echo   [9] 🌐 Mudar Idioma (EN / PT / ES / IT)
    echo   [0] ❌ Sair
    echo.
    echo =====================================================================
    set /p OPCAO="Digite o número da opção (0-5, 9): "
)

if "%OPCAO%"=="1" (
    echo.
    if "%APP_LANG%"=="EN" echo ▶ Running automated API system tests...
    if "%APP_LANG%"=="ES" echo ▶ Ejecutando pruebas automatizadas de sistema...
    if "%APP_LANG%"=="IT" echo ▶ Esecuzione test di sistema automatizzati...
    if "%APP_LANG%"=="PT" echo ▶ Executando testes automatizados de sistema...
    %PHP_BIN% test_sistema_api.php %*
) else if "%OPCAO%"=="2" (
    echo.
    if "%APP_LANG%"=="EN" echo ▶ Running voting terminal simulator...
    if "%APP_LANG%"=="ES" echo ▶ Ejecutando simulador de terminal electoral...
    if "%APP_LANG%"=="IT" echo ▶ Esecuzione simulatore del terminale elettorale...
    if "%APP_LANG%"=="PT" echo ▶ Executando simulador de terminal eleitoral...
    %PHP_BIN% simulador_poke.php %*
) else if "%OPCAO%"=="3" (
    echo.
    if "%APP_LANG%"=="EN" echo ▶ Running mass load & stress test simulator...
    if "%APP_LANG%"=="ES" echo ▶ Ejecutando simulador de carga y estrés masivo...
    if "%APP_LANG%"=="IT" echo ▶ Esecuzione simulatore di carico e stress...
    if "%APP_LANG%"=="PT" echo ▶ Executando simulador de carga e estresse...
    %PHP_BIN% simulador_eleicao_massa.php 50 10 %*
) else if "%OPCAO%"=="4" (
    echo.
    if "%APP_LANG%"=="EN" echo ▶ Running keypad simulator and ballot digit validator...
    if "%APP_LANG%"=="ES" echo ▶ Ejecutando simulador de teclado virtual y validador...
    if "%APP_LANG%"=="IT" echo ▶ Esecuzione simulatore del tastierino e validatore...
    if "%APP_LANG%"=="PT" echo ▶ Executando simulador de teclado virtual e validador de votos...
    %PHP_BIN% simulador_teclado_matricial.php
) else if "%OPCAO%"=="5" (
    echo.
    if "%APP_LANG%"=="EN" echo ▶ Opening Visual Dashboard in browser...
    if "%APP_LANG%"=="ES" echo ▶ Abriendo Panel Visual en el navegador...
    if "%APP_LANG%"=="IT" echo ▶ Apertura Cruscotto Visivo nel browser...
    if "%APP_LANG%"=="PT" echo ▶ Abrindo Dashboard Visual no navegador...
    start index.html
) else if "%OPCAO%"=="9" (
    goto LANG_SELECT
) else (
    echo Exiting / Saindo...
    exit /b 0
)

echo.
echo =====================================================================
pause
goto MENU
