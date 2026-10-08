@echo off
REM ==============================================================================
REM EXECUTOR DA SUÍTE DE TESTES E SIMULADORES (WINDOWS)
REM Urna Eletrônica Pokémon • POKE
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"

echo =====================================================================
echo    🧪 PAINEL DE TESTES E SIMULADORES • URNA ELETRÔNICA POKÉMON
echo =====================================================================
echo.
echo Escolha o teste ou simulador que deseja executar:
echo.
echo  [1] 🧪 Executar Bateria Completa de Testes de Sistema (API REST)
echo  [2] 🤖 Executar Simulador do Terminal Eleitoral POKE (Votação Unitária)
echo  [3] ⚡ Executar Simulador de Eleição em Massa (Teste de Carga / 50 Eleitores)
echo  [4] ⌨️ Executar Simulador do Teclado Virtual & Validador de Votos
echo  [5] 🌐 Abrir Dashboard Visual de Testes no Navegador (tests/index.html)
echo  [0] Sair
echo.
set /p OPCAO="Digite o número da opção (0-5): "

set PHP_BIN=php
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\xampp\php\php.exe" (
        set PHP_BIN=C:\xampp\php\php.exe
    ) else if exist "C:\laragon\bin\php\php.exe" (
        set PHP_BIN=C:\laragon\bin\php\php.exe
    )
)

if "%OPCAO%"=="1" (
    echo.
    echo ▶ Executando testes automatizados de sistema...
    %PHP_BIN% test_sistema_api.php %*
) else if "%OPCAO%"=="2" (
    echo.
    echo ▶ Executando simulador de terminal eleitoral...
    %PHP_BIN% simulador_poke.php %*
) else if "%OPCAO%"=="3" (
    echo.
    echo ▶ Executando simulador de carga e estresse...
    %PHP_BIN% simulador_eleicao_massa.php 50 10 %*
) else if "%OPCAO%"=="4" (
    echo.
    echo ▶ Executando simulador de teclado virtual e validador de votos...
    %PHP_BIN% simulador_teclado_matricial.php
) else if "%OPCAO%"=="5" (
    echo.
    echo ▶ Abrindo Dashboard Visual no navegador padrão...
    start index.html
) else (
    echo Saindo...
    exit /b 0
)

echo.
echo =====================================================================
pause
