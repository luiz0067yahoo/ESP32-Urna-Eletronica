@echo off
REM ==============================================================================
REM POKÉMON ELECTRONIC VOTING MACHINE • MULTI-ENVIRONMENT LAUNCHER (WINDOWS)
REM URNA ELETRÔNICA POKÉMON • CENTRAL DE INICIALIZAÇÃO MULTI-AMBIENTE
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Check if language was passed as argument (%1)
if /i "%~1"=="en" (set APP_LANG=EN& goto MENU)
if /i "%~1"=="pt" (set APP_LANG=PT& goto MENU)
if /i "%~1"=="es" (set APP_LANG=ES& goto MENU)
if /i "%~1"=="it" (set APP_LANG=IT& goto MENU)

:LANG_SELECT
cls
echo =====================================================================
echo    🗳️ POKÉMON ELECTRONIC VOTING MACHINE / URNA ELETRÔNICA
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

:MENU
cls
if "%APP_LANG%"=="EN" (
    echo =====================================================================
    echo    🗳️ POKÉMON ELECTRONIC VOTING MACHINE • ENVIRONMENT LAUNCHER
    echo =====================================================================
    echo.
    echo  Choose the runtime environment:
    echo.
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Compose      (Containers via Podman)
    echo   [3] ☸️ Kubernetes          (Deploy K8s Manifests / Ingress)
    echo   [4] 🐘 Local PHP + MySQL   (PHP Built-in Server / XAMPP / Native)
    echo   [5] 🛑 Stop Services       (Stop Docker, Podman, or Local PHP)
    echo   [9] 🌐 Change Language     (EN / PT / ES / IT)
    echo   [0] ❌ Exit
    echo.
    echo =====================================================================
    set /p OPCAO="Enter your choice (0-5, 9): "
) else if "%APP_LANG%"=="ES" (
    echo =====================================================================
    echo    🗳️ URNA ELECTRÓNICA POKÉMON • CENTRAL DE INICIO
    echo =====================================================================
    echo.
    echo  Elige el entorno en el que deseas ejecutar la aplicación:
    echo.
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Compose      (Contenedores vía Podman)
    echo   [3] ☸️ Kubernetes          (Despliegue de Manifiestos K8s / Ingress)
    echo   [4] 🐘 PHP + MySQL Local   (Servidor Integrado PHP / XAMPP / Nativo)
    echo   [5] 🛑 Detener Servicios   (Apagar Docker, Podman o PHP Local)
    echo   [9] 🌐 Cambiar Idioma      (EN / PT / ES / IT)
    echo   [0] ❌ Salir
    echo.
    echo =====================================================================
    set /p OPCAO="Introduce el número de opción (0-5, 9): "
) else if "%APP_LANG%"=="IT" (
    echo =====================================================================
    echo    🗳️ URNA ELETTRONICA POKÉMON • CENTRO DI AVVIO
    echo =====================================================================
    echo.
    echo  Scegli l'ambiente in cui desideri eseguire l'applicazione:
    echo.
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Compose      (Container tramite Podman)
    echo   [3] ☸️ Kubernetes          (Distribuzione Manifesti K8s / Ingress)
    echo   [4] 🐘 PHP + MySQL Locale  (Server Integrato PHP / XAMPP / Nativo)
    echo   [5] 🛑 Ferma Servizi       (Arresta Docker, Podman o PHP Locale)
    echo   [9] 🌐 Cambia Lingua       (EN / PT / ES / IT)
    echo   [0] ❌ Esci
    echo.
    echo =====================================================================
    set /p OPCAO="Inserisci il numero dell'opzione (0-5, 9): "
) else (
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
    echo   [9] 🌐 Mudar Idioma        (EN / PT / ES / IT)
    echo   [0] ❌ Sair
    echo.
    echo =====================================================================
    set /p OPCAO="Digite o número da opção (0-5, 9): "
)

if "%OPCAO%"=="1" goto DOCKER
if "%OPCAO%"=="2" goto PODMAN
if "%OPCAO%"=="3" goto KUBERNETES
if "%OPCAO%"=="4" goto LOCAL_PHP
if "%OPCAO%"=="5" goto STOP_ALL
if "%OPCAO%"=="9" goto LANG_SELECT
if "%OPCAO%"=="0" goto SAIR

echo.
if "%APP_LANG%"=="EN" echo [WARNING] Invalid option!
if "%APP_LANG%"=="ES" echo [AVISO] ¡Opción inválida!
if "%APP_LANG%"=="IT" echo [AVVISO] Opzione non valida!
if "%APP_LANG%"=="PT" echo [AVISO] Opção inválida!
timeout /t 2 >nul
goto MENU


REM ==============================================================================
REM 1. DOCKER COMPOSE
REM ==============================================================================
:DOCKER
echo.
echo =====================================================================
if "%APP_LANG%"=="EN" echo   🐳 STARTING DOCKER ENVIRONMENT
if "%APP_LANG%"=="ES" echo   🐳 INICIANDO ENTORNO DOCKER
if "%APP_LANG%"=="IT" echo   🐳 AVVIO AMBIENTE DOCKER
if "%APP_LANG%"=="PT" echo   🐳 INICIANDO AMBIENTE DOCKER
echo =====================================================================
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" (
        echo ❌ [ERROR] 'docker' command was not found in PATH.
        echo 👉 Install Docker Desktop: https://www.docker.com/products/docker-desktop/
        echo 👉 Or use option [4] to run with Local PHP + MySQL.
    ) else if "%APP_LANG%"=="ES" (
        echo ❌ [ERROR] El comando 'docker' no se encontró en el PATH.
        echo 👉 Instala Docker Desktop: https://www.docker.com/products/docker-desktop/
        echo 👉 O usa la opción [4] para ejecutar con PHP + MySQL Local.
    ) else if "%APP_LANG%"=="IT" (
        echo ❌ [ERRORE] Il comando 'docker' non è stato trovato nel PATH.
        echo 👉 Installa Docker Desktop: https://www.docker.com/products/docker-desktop/
        echo 👉 Oppure usa l'opzione [4] per eseguire con PHP + MySQL Locale.
    ) else (
        echo ❌ [ERRO] O comando 'docker' não foi encontrado no PATH do sistema.
        echo 👉 Instale o Docker Desktop: https://www.docker.com/products/docker-desktop/
        echo 👉 Ou utilize a opção [4] para executar com PHP + MySQL Local.
    )
    echo.
    pause
    goto MENU
)

docker info >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" (
        echo ⚠️ [WARNING] Docker daemon is not responding. Please start Docker Desktop.
    ) else if "%APP_LANG%"=="ES" (
        echo ⚠️ [AVISO] El servicio de Docker no responde. Abre Docker Desktop.
    ) else if "%APP_LANG%"=="IT" (
        echo ⚠️ [AVVISO] Il demone Docker non risponde. Apri Docker Desktop.
    ) else (
        echo ⚠️ [AVISO] O serviço do Docker não está respondendo. Abra o Docker Desktop.
    )
    echo.
    pause
    goto MENU
)

if not exist "devops\docker\.env" (
    if exist "devops\docker\.env.example" (
        copy "devops\docker\.env.example" "devops\docker\.env" >nul
    )
)

if "%APP_LANG%"=="EN" echo ▶ Starting containers with Docker Compose...
if "%APP_LANG%"=="ES" echo ▶ Levantando contenedores con Docker Compose...
if "%APP_LANG%"=="IT" echo ▶ Avvio dei container con Docker Compose...
if "%APP_LANG%"=="PT" echo ▶ Subindo contêineres com Docker Compose...
docker compose -f "devops\docker\docker-compose.yml" up -d --build

if %ERRORLEVEL% EQU 0 (
    echo.
    if "%APP_LANG%"=="EN" (
        echo ✔ Docker environment started successfully!
        echo    👉 Voting Booth: http://localhost:8080/frontend/index.html
        echo    👉 Live Results: http://localhost:8080/frontend/apuracao.html
        echo    👉 phpMyAdmin:   http://localhost:8081
        echo.
        set /p ABRIR="Do you want to open the Voting Booth in your browser now? (Y/N): "
        if /i "!ABRIR!"=="Y" start http://localhost:8080/frontend/index.html
    ) else if "%APP_LANG%"=="ES" (
        echo ✔ ¡Entorno Docker iniciado con éxito!
        echo    👉 Cabina de Votación: http://localhost:8080/frontend/index.html
        echo    👉 Escrutinio en Vivo: http://localhost:8080/frontend/apuracao.html
        echo    👉 phpMyAdmin:         http://localhost:8081
        echo.
        set /p ABRIR="¿Deseas abrir la Cabina de Votación en el navegador ahora? (S/N): "
        if /i "!ABRIR!"=="S" start http://localhost:8080/frontend/index.html
    ) else if "%APP_LANG%"=="IT" (
        echo ✔ Ambiente Docker avviato con successo!
        echo    👉 Cabina Elettorale: http://localhost:8080/frontend/index.html
        echo    👉 Scrutinio dal Vivo: http://localhost:8080/frontend/apuracao.html
        echo    👉 phpMyAdmin:         http://localhost:8081
        echo.
        set /p ABRIR="Vuoi aprire la Cabina di Voto nel browser adesso? (S/N): "
        if /i "!ABRIR!"=="S" start http://localhost:8080/frontend/index.html
    ) else (
        echo ✔ Ambiente Docker iniciado com sucesso!
        echo    👉 Cabine de Votação: http://localhost:8080/frontend/index.html
        echo    👉 Apuração ao Vivo:  http://localhost:8080/frontend/apuracao.html
        echo    👉 phpMyAdmin:        http://localhost:8081
        echo.
        set /p ABRIR="Deseja abrir a Urna Eletrônica no navegador agora? (S/N): "
        if /i "!ABRIR!"=="S" start http://localhost:8080/frontend/index.html
    )
) else (
    echo.
    if "%APP_LANG%"=="EN" echo ❌ Failed to start Docker containers.
    if "%APP_LANG%"=="ES" echo ❌ Error al iniciar contenedores Docker.
    if "%APP_LANG%"=="IT" echo ❌ Errore nell'avvio dei container Docker.
    if "%APP_LANG%"=="PT" echo ❌ Falha ao subir contêineres Docker.
)
pause
goto MENU


REM ==============================================================================
REM 2. PODMAN COMPOSE
REM ==============================================================================
:PODMAN
echo.
echo =====================================================================
if "%APP_LANG%"=="EN" echo   🦭 STARTING PODMAN ENVIRONMENT
if "%APP_LANG%"=="ES" echo   🦭 INICIANDO ENTORNO PODMAN
if "%APP_LANG%"=="IT" echo   🦭 AVVIO AMBIENTE PODMAN
if "%APP_LANG%"=="PT" echo   🦭 INICIANDO AMBIENTE PODMAN
echo =====================================================================
where podman >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" echo ❌ [ERROR] 'podman' command was not found in PATH: https://podman-desktop.io/
    if "%APP_LANG%"=="ES" echo ❌ [ERROR] El comando 'podman' no fue encontrado: https://podman-desktop.io/
    if "%APP_LANG%"=="IT" echo ❌ [ERRORE] Il comando 'podman' non è stato trovato: https://podman-desktop.io/
    if "%APP_LANG%"=="PT" echo ❌ [ERRO] O comando 'podman' não foi encontrado: https://podman-desktop.io/
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
    if "%APP_LANG%"=="EN" echo ✔ Podman environment started successfully!
    if "%APP_LANG%"=="ES" echo ✔ ¡Entorno Podman iniciado con éxito!
    if "%APP_LANG%"=="IT" echo ✔ Ambiente Podman avviato con successo!
    if "%APP_LANG%"=="PT" echo ✔ Ambiente Podman iniciado com sucesso!
    echo    👉 Cabine/Booth: http://localhost:8080/frontend/index.html
    echo    👉 Results:      http://localhost:8080/frontend/apuracao.html
    start http://localhost:8080/frontend/index.html
) else (
    echo.
    echo ❌ Failed / Falha Podman.
)
pause
goto MENU


REM ==============================================================================
REM 3. KUBERNETES
REM ==============================================================================
:KUBERNETES
echo.
echo =====================================================================
if "%APP_LANG%"=="EN" echo   ☸️ DEPLOY TO KUBERNETES CLUSTER
if "%APP_LANG%"=="ES" echo   ☸️ DESPLIEGUE EN CLÚSTER KUBERNETES
if "%APP_LANG%"=="IT" echo   ☸️ DISTRIBUZIONE SU CLUSTER KUBERNETES
if "%APP_LANG%"=="PT" echo   ☸️ DEPLOY EM CLUSTER KUBERNETES
echo =====================================================================
where kubectl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" echo ❌ [ERROR] 'kubectl' command was not found in PATH.
    if "%APP_LANG%"=="ES" echo ❌ [ERROR] El comando 'kubectl' no fue encontrado en el PATH.
    if "%APP_LANG%"=="IT" echo ❌ [ERRORE] Il comando 'kubectl' non è stato trovato nel PATH.
    if "%APP_LANG%"=="PT" echo ❌ [ERRO] O comando 'kubectl' não foi encontrado no PATH.
    echo.
    pause
    goto MENU
)

call "devops\kubernetes\deploy.bat"
goto MENU


REM ==============================================================================
REM 4. LOCAL PHP + MYSQL
REM ==============================================================================
:LOCAL_PHP
echo.
echo =====================================================================
if "%APP_LANG%"=="EN" echo   🐘 STARTING LOCAL PHP + MYSQL
if "%APP_LANG%"=="ES" echo   🐘 INICIANDO CON PHP + MYSQL LOCAL
if "%APP_LANG%"=="IT" echo   🐘 AVVIO CON PHP + MYSQL LOCALE
if "%APP_LANG%"=="PT" echo   🐘 INICIANDO COM PHP + MYSQL LOCAL
echo =====================================================================
set PHP_BIN=php
where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\xampp\php\php.exe" (
        set PHP_BIN=C:\xampp\php\php.exe
    ) else if exist "C:\laragon\bin\php\php.exe" (
        set PHP_BIN=C:\laragon\bin\php\php.exe
    ) else (
        echo.
        if "%APP_LANG%"=="EN" (
            echo ⚠️ [WARNING] 'php' command was not found in system PATH.
            echo 👉 If using XAMPP: start Apache and MySQL, or add C:\xampp\php to PATH.
        ) else if "%APP_LANG%"=="ES" (
            echo ⚠️ [AVISO] El comando 'php' no fue encontrado en el PATH.
            echo 👉 Si usas XAMPP: inicia Apache y MySQL, o agrega C:\xampp\php al PATH.
        ) else if "%APP_LANG%"=="IT" (
            echo ⚠️ [AVVISO] Il comando 'php' non è stato trovato nel PATH.
            echo 👉 Se usi XAMPP: avvia Apache e MySQL, o aggiungi C:\xampp\php al PATH.
        ) else (
            echo ⚠️ [AVISO] O comando 'php' não foi encontrado no PATH do sistema.
            echo 👉 Se usa XAMPP: inicie o Apache e MySQL, ou adicione C:\xampp\php ao PATH.
        )
        echo.
        pause
        goto MENU
    )
)

if "%APP_LANG%"=="EN" echo 1. Verifying and migrating database via PHP...
if "%APP_LANG%"=="ES" echo 1. Verificando y migrando base de datos vía PHP...
if "%APP_LANG%"=="IT" echo 1. Verifica e migrazione del database tramite PHP...
if "%APP_LANG%"=="PT" echo 1. Verificando/instalando banco de dados via PHP...
%PHP_BIN% db/install.php

echo.
if "%APP_LANG%"=="EN" (
    echo 2. Starting PHP Built-in Server on port 8080...
    start "Pokémon Ballot Box • PHP Server (Port 8080)" %PHP_BIN% -S localhost:8080
) else if "%APP_LANG%"=="ES" (
    echo 2. Iniciando Servidor Integrado PHP en el puerto 8080...
    start "Urna Electrónica • Servidor PHP (Puerto 8080)" %PHP_BIN% -S localhost:8080
) else if "%APP_LANG%"=="IT" (
    echo 2. Avvio del Server Integrato PHP sulla porta 8080...
    start "Urna Elettronica • Server PHP (Porta 8080)" %PHP_BIN% -S localhost:8080
) else (
    echo 2. Iniciando Servidor Embutido do PHP na porta 8080...
    start "Urna Eletrônica • PHP Server (Porta 8080)" %PHP_BIN% -S localhost:8080
)

timeout /t 2 >nul
echo.
if "%APP_LANG%"=="EN" echo ✔ Local PHP Server running at http://localhost:8080!
if "%APP_LANG%"=="ES" echo ✔ Servidor PHP Local ejecutándose en http://localhost:8080!
if "%APP_LANG%"=="IT" echo ✔ Server PHP Locale in esecuzione su http://localhost:8080!
if "%APP_LANG%"=="PT" echo ✔ Servidor PHP Local iniciado em http://localhost:8080!
echo    👉 Booth / Urna: http://localhost:8080/frontend/index.html
echo    👉 Live Results: http://localhost:8080/frontend/apuracao.html
echo.
start http://localhost:8080/frontend/index.html
pause
goto MENU


REM ==============================================================================
REM 5. STOP SERVICES
REM ==============================================================================
:STOP_ALL
echo.
echo =====================================================================
if "%APP_LANG%"=="EN" echo   🛑 STOPPING ALL RUNNING SERVICES
if "%APP_LANG%"=="ES" echo   🛑 DETENIENDO TODOS LOS SERVICIOS EN EJECUCIÓN
if "%APP_LANG%"=="IT" echo   🛑 ARRESTO DI TUTTI I SERVIZI IN ESECUZIONE
if "%APP_LANG%"=="PT" echo   🛑 PARANDO TODOS OS SERVIÇOS EM EXECUÇÃO
echo =====================================================================

where docker >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    if "%APP_LANG%"=="EN" echo ▶ Stopping Docker Compose...
    if "%APP_LANG%"=="ES" echo ▶ Deteniendo Docker Compose...
    if "%APP_LANG%"=="IT" echo ▶ Arresto Docker Compose...
    if "%APP_LANG%"=="PT" echo ▶ Parando Docker Compose...
    docker compose -f "devops\docker\docker-compose.yml" down 2>nul
)

where podman >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    if "%APP_LANG%"=="EN" echo ▶ Stopping Podman Compose...
    if "%APP_LANG%"=="ES" echo ▶ Deteniendo Podman Compose...
    if "%APP_LANG%"=="IT" echo ▶ Arresto Podman Compose...
    if "%APP_LANG%"=="PT" echo ▶ Parando Podman Compose...
    podman compose -f "devops\podman\podman-compose.yml" down 2>nul
)

if "%APP_LANG%"=="EN" echo ▶ Terminating local PHP server processes...
if "%APP_LANG%"=="ES" echo ▶ Terminando procesos del servidor PHP local...
if "%APP_LANG%"=="IT" echo ▶ Terminazione dei processi server PHP locale...
if "%APP_LANG%"=="PT" echo ▶ Encerrando processos locais de servidor PHP embutido...
taskkill /FI "WINDOWTITLE eq *PHP Server*" /T /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Urna Eletrônica*" /T /F >nul 2>nul

echo.
if "%APP_LANG%"=="EN" echo ✔ All services have been stopped!
if "%APP_LANG%"=="ES" echo ✔ ¡Todos los servicios han sido detenidos!
if "%APP_LANG%"=="IT" echo ✔ Tutti i servizi sono stati arrestati!
if "%APP_LANG%"=="PT" echo ✔ Todos os serviços foram encerrados!
pause
goto MENU


:SAIR
echo.
if "%APP_LANG%"=="EN" echo Exiting launcher...
if "%APP_LANG%"=="ES" echo Saliendo del iniciador...
if "%APP_LANG%"=="IT" echo Uscita dall'avviatore...
if "%APP_LANG%"=="PT" echo Saindo da Central de Inicialização...
exit /b 0
