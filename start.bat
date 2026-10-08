@echo off
REM ==============================================================================
REM URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO MULTI-AMBIENTE (WINDOWS)
REM Permite escolher entre Docker, Podman, Kubernetes ou PHP/MySQL Local
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

:MENU
cls
echo =====================================================================
echo    🗳️ URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO
echo =====================================================================
echo.
echo  Escolha o ambiente em que deseja rodar a aplicação:
echo.
echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
echo   [2] 🦭 Podman Compose      (Contêineres via Podman)
echo   [3] ☸️ Kubernetes          (Deploy de Manifestos K8s / Ingress)
echo   [4] 🐘 PHP + MySQL Local   (Servidor Embutido PHP / XAMPP / Nativo)
echo   [5] 🛑 Parar Serviços      (Derrubar Docker, Podman ou PHP Local)
echo   [0] ❌ Sair
echo.
echo =====================================================================
set /p OPCAO="Digite o número da opção (0-5): "

if "%OPCAO%"=="1" goto DOCKER
if "%OPCAO%"=="2" goto PODMAN
if "%OPCAO%"=="3" goto KUBERNETES
if "%OPCAO%"=="4" goto LOCAL_PHP
if "%OPCAO%"=="5" goto STOP_ALL
if "%OPCAO%"=="0" goto SAIR

echo.
echo [AVISO] Opção inválida! Escolha um número de 0 a 5.
timeout /t 2 >nul
goto MENU


REM ==============================================================================
REM 1. DOCKER COMPOSE
REM ==============================================================================
:DOCKER
echo.
echo =====================================================================
echo   🐳 INICIANDO AMBIENTE DOCKER
echo =====================================================================
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ [ERRO] O comando 'docker' não foi encontrado no PATH do sistema.
    echo 👉 Instale o Docker Desktop: https://www.docker.com/products/docker-desktop/
    echo 👉 Ou utilize a opção [4] para executar com PHP + MySQL Local.
    echo.
    pause
    goto MENU
)

docker info >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠️ [AVISO] O serviço do Docker não está respondendo.
    echo 👉 Abra o 'Docker Desktop' no Windows e aguarde ele inicializar.
    echo.
    pause
    goto MENU
)

if not exist "devops\docker\.env" (
    if exist "devops\docker\.env.example" (
        copy "devops\docker\.env.example" "devops\docker\.env" >nul
    )
)

echo ▶ Subindo contêineres com Docker Compose...
docker compose -f "devops\docker\docker-compose.yml" up -d --build

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✔ Ambiente Docker iniciado com sucesso!
    echo    👉 Cabine de Votação: http://localhost:8080/frontend/index.html
    echo    👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html
    echo    👉 phpMyAdmin:        http://localhost:8081
    echo.
    set /p ABRIR="Deseja abrir a Urna Eletrônica no navegador agora? (S/N): "
    if /i "!ABRIR!"=="S" start http://localhost:8080/frontend/index.html
) else (
    echo.
    echo ❌ Falha ao subir contêineres Docker. Verifique as mensagens de erro acima.
)
pause
goto MENU


REM ==============================================================================
REM 2. PODMAN COMPOSE
REM ==============================================================================
:PODMAN
echo.
echo =====================================================================
echo   🦭 INICIANDO AMBIENTE PODMAN
echo =====================================================================
where podman >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ [ERRO] O comando 'podman' não foi encontrado no PATH do sistema.
    echo 👉 Instale o Podman Desktop: https://podman-desktop.io/
    echo.
    pause
    goto MENU
)

if not exist "devops\podman\.env" (
    if exist "devops\podman\.env.example" (
        copy "devops\podman\.env.example" "devops\podman\.env" >nul
    )
)

where podman-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    podman-compose -f "devops\podman\podman-compose.yml" up -d --build
) else (
    podman compose -f "devops\podman\podman-compose.yml" up -d --build
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✔ Ambiente Podman iniciado com sucesso!
    echo    👉 Cabine de Votação: http://localhost:8080/frontend/index.html
    echo    👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html
    echo.
    set /p ABRIR="Deseja abrir no navegador agora? (S/N): "
    if /i "!ABRIR!"=="S" start http://localhost:8080/frontend/index.html
) else (
    echo.
    echo ❌ Falha ao iniciar serviços com Podman.
)
pause
goto MENU


REM ==============================================================================
REM 3. KUBERNETES
REM ==============================================================================
:KUBERNETES
echo.
echo =====================================================================
echo   ☸️ DEPLOY EM CLUSTER KUBERNETES
echo =====================================================================
where kubectl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ [ERRO] O comando 'kubectl' não foi encontrado no PATH do sistema.
    echo 👉 Certifique-se de ter um cluster K8s ativo (Minikube, K3s ou Docker Desktop K8s).
    echo.
    pause
    goto MENU
)

call "devops\kubernetes\deploy.bat"
goto MENU


REM ==============================================================================
REM 4. PHP + MYSQL LOCAL (SERVIDOR EMBUTIDO / XAMPP)
REM ==============================================================================
:LOCAL_PHP
echo.
echo =====================================================================
echo   🐘 INICIANDO COM PHP + MYSQL LOCAL
echo =====================================================================
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠️ [AVISO] O comando 'php' não foi encontrado no PATH do sistema.
    echo.
    echo 👉 Se você usa XAMPP ou WampServer:
    echo    1. Abra o painel do XAMPP e clique em START no Apache e no MySQL.
    echo    2. Copie a pasta do projeto para 'C:\xampp\htdocs\'.
    echo    3. Abra no navegador: http://localhost/ESP32-Urna-Eletronica/frontend/index.html
    echo.
    echo 👉 Se deseja adicionar o PHP ao PATH:
    echo    Adicione 'C:\xampp\php' às Variáveis de Ambiente do Windows.
    echo.
    pause
    goto MENU
)

echo 1. Verificando/instalando banco de dados MySQL via PHP...
php db/install.php

echo.
echo 2. Iniciando Servidor Embutido do PHP na porta 8080...
echo    (Uma nova janela de console será aberta para manter o servidor ativo)
start "Urna Eletrônica • PHP Server (Porta 8080)" php -S localhost:8080

timeout /t 2 >nul
echo.
echo ✔ Servidor PHP Local iniciado em http://localhost:8080!
echo    👉 Cabine de Votação: http://localhost:8080/frontend/index.html
echo    👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html
echo.
start http://localhost:8080/frontend/index.html
pause
goto MENU


REM ==============================================================================
REM 5. PARAR SERVIÇOS
REM ==============================================================================
:STOP_ALL
echo.
echo =====================================================================
echo   🛑 PARANDO TODOS OS SERVIÇOS EM EXECUÇÃO
echo =====================================================================

where docker >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ▶ Parando Docker Compose...
    docker compose -f "devops\docker\docker-compose.yml" down 2>nul
)

where podman >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ▶ Parando Podman Compose...
    podman compose -f "devops\podman\podman-compose.yml" down 2>nul
)

echo ▶ Encerrando processos locais de servidor PHP embutido...
taskkill /FI "WINDOWTITLE eq Urna Eletrônica • PHP Server*" /T /F >nul 2>nul

echo.
echo ✔ Todos os serviços foram encerrados!
pause
goto MENU


:SAIR
echo.
echo Saindo da Central de Inicialização...
exit /b 0
