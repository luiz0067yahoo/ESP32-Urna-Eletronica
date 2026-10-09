@echo off
REM ==============================================================================
REM PODMAN NATIVE POD LAUNCHER (WINDOWS)
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

set POD_NAME=urna-pod
set APP_IMAGE=urna-app:podman

if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

echo ==========================================================
echo   🦭 PODMAN NATIVE POD LAUNCHER
echo ==========================================================
echo  Select Language / Selecione o Idioma / Seleccione / Seleziona:
echo   [1] 🇺🇸 English (Default)
echo   [2] 🇧🇷 Português
echo   [3] 🇪🇸 Español
echo   [4] 🇮🇹 Italiano
set /p LANG_CHOICE="Choice [1-4] (Press ENTER for English): "
if "%LANG_CHOICE%"=="" set LANG_CHOICE=1
if "%LANG_CHOICE%"=="2" (set APP_LANG=PT) else if "%LANG_CHOICE%"=="3" (set APP_LANG=ES) else if "%LANG_CHOICE%"=="4" (set APP_LANG=IT) else (set APP_LANG=EN)

:RUN
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

if not exist "%PROJECT_ROOT%\.env" (
    if exist "%PROJECT_ROOT%\.env.example" (
        copy "%PROJECT_ROOT%\.env.example" "%PROJECT_ROOT%\.env" >nul
    )
)

set "DB_NAME=urna"
set "DB_USER=urna"
set "DB_PASS=urna123"
set "MYSQL_ROOT_PASSWORD=rootpassword"
set "APP_PORT=8080"
set "DB_PORT=3306"

if exist "%PROJECT_ROOT%\.env" (
    for /f "usebackq tokens=1,* delims==" %%A in ("%PROJECT_ROOT%\.env") do (
        set "line=%%A"
        if not "!line:~0,1!"=="#" if not "!line:~0,1!"==";" (
            set "%%A=%%B"
        )
    )
)

echo ==========================================================
if "%APP_LANG%"=="EN" echo   🚀 STARTING PODMAN NATIVE POD (%POD_NAME%)
if "%APP_LANG%"=="ES" echo   🚀 INICIANDO POD NATIVO PODMAN (%POD_NAME%)
if "%APP_LANG%"=="IT" echo   🚀 AVVIO POD NATIVO PODMAN (%POD_NAME%)
if "%APP_LANG%"=="PT" echo   🚀 INICIANDO POD NATIVO PODMAN (%POD_NAME%)
echo ==========================================================

podman pod rm -f %POD_NAME% 2>nul

if "%APP_LANG%"=="EN" echo 1. Creating Pod '%POD_NAME%' on port %APP_PORT%...
if "%APP_LANG%"=="ES" echo 1. Creando Pod '%POD_NAME%' en puerto %APP_PORT%...
if "%APP_LANG%"=="IT" echo 1. Creazione Pod '%POD_NAME%' sulla porta %APP_PORT%...
if "%APP_LANG%"=="PT" echo 1. Criando Pod '%POD_NAME%' com porta %APP_PORT%...
podman pod create --name %POD_NAME% -p %APP_PORT%:80

if "%APP_LANG%"=="EN" echo 2. Starting MariaDB inside Pod...
if "%APP_LANG%"=="ES" echo 2. Iniciando MariaDB dentro del Pod...
if "%APP_LANG%"=="IT" echo 2. Avvio MariaDB nel Pod...
if "%APP_LANG%"=="PT" echo 2. Subindo MariaDB no Pod...
podman run -d --name urna-db --pod %POD_NAME% --restart unless-stopped -e MYSQL_DATABASE=%DB_NAME% -e MYSQL_USER=%DB_USER% -e MYSQL_PASSWORD=%DB_PASS% -e MYSQL_ROOT_PASSWORD=%MYSQL_ROOT_PASSWORD% -v urna_pod_db_data:/var/lib/mysql:Z docker.io/library/mariadb:10.11

if "%APP_LANG%"=="EN" echo 3. Building %APP_IMAGE% image...
if "%APP_LANG%"=="ES" echo 3. Construyendo imagen %APP_IMAGE%...
if "%APP_LANG%"=="IT" echo 3. Compilazione immagine %APP_IMAGE%...
if "%APP_LANG%"=="PT" echo 3. Construindo imagem %APP_IMAGE%...
podman build -t %APP_IMAGE% -f Containerfile "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 4. Starting Ballot Box app inside Pod...
if "%APP_LANG%"=="ES" echo 4. Iniciando aplicación de la Urna en el Pod...
if "%APP_LANG%"=="IT" echo 4. Avvio applicazione Urna nel Pod...
if "%APP_LANG%"=="PT" echo 4. Subindo aplicacao Urna no Pod...
podman run -d --name urna-app --pod %POD_NAME% --restart unless-stopped -e DB_HOST=127.0.0.1 -e DB_PORT=%DB_PORT% -e DB_NAME=%DB_NAME% -e DB_USER=%DB_USER% -e DB_PASS=%DB_PASS% %APP_IMAGE%

echo.
if "%APP_LANG%"=="EN" (
    echo ✔ Podman Pod '%POD_NAME%' started successfully!
    echo    👉 Voting Booth: http://localhost:8080/frontend/index.html
    echo    👉 Live Results: http://localhost:8080/frontend/apuracao.html
    echo    👉 RESTful API:  http://localhost:8080/backend/apuracao
) else if "%APP_LANG%"=="ES" (
    echo ✔ ¡Podman Pod '%POD_NAME%' iniciado con éxito!
    echo    👉 Cabina de Votación: http://localhost:8080/frontend/index.html
    echo    👉 Escrutinio en Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
) else if "%APP_LANG%"=="IT" (
    echo ✔ Podman Pod '%POD_NAME%' avviato con successo!
    echo    👉 Cabina Elettorale:  http://localhost:8080/frontend/index.html
    echo    👉 Scrutinio dal Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
) else (
    echo ✔ Podman Pod '%POD_NAME%' iniciado com sucesso!
    echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
    echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
)
echo.
pause
