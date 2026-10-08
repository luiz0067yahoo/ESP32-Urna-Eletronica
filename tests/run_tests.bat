@echo off
REM ==============================================================================
REM EXECUTOR DA SUÍTE DE TESTES E SIMULADORES (WINDOWS)
REM Urna Eletrônica Pokémon • ESP32
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
echo  [2] 🤖 Executar Simulador de Firmware ESP32 (Votação Unitária)
echo  [3] ⚡ Executar Simulador de Eleição em Massa (Teste de Carga / 50 Eleitores)
echo  [4] ⌨️ Executar Simulador do Teclado Matricial 4x4 (Hardware Scanner)
echo  [5] 🌐 Abrir Dashboard Visual de Testes no Navegador (tests/index.html)
echo  [0] Sair
echo.
set /p OPCAO="Digite o número da opção (0-5): "

if "%OPCAO%"=="1" (
    echo.
    echo ▶ Executando testes automatizados de sistema...
    python test_sistema_api.py %*
) else if "%OPCAO%"=="2" (
    echo.
    echo ▶ Executando simulador de firmware ESP32...
    python simulador_esp32.py %*
) else if "%OPCAO%"=="3" (
    echo.
    echo ▶ Executando simulador de carga e estresse...
    python simulador_eleicao_massa.py 50 10 %*
) else if "%OPCAO%"=="4" (
    echo.
    echo ▶ Executando simulador de teclado matricial...
    python simulador_teclado_matricial.py
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
