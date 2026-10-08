@echo off
REM ==============================================================================
REM DOCKER LAUNCHER (WINDOWS) - POKÉMON ELECTRONIC VOTING MACHINE
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Check if language was passed as argument
if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

echo ==========================================================
echo   🐳 DOCKER ENVIRONMENT LAUNCHER
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
if not exist .env (
    if exist .env.example (
        if "%APP_LANG%"=="EN" echo Creating .env file from .env.example...
        if "%APP_LANG%"=="ES" echo Creando archivo .env desde .env.example...
        if "%APP_LANG%"=="IT" echo Creazione file .env da .env.example...
        if "%APP_LANG%"=="PT" echo Criando arquivo .env a partir de .env.example...
        copy .env.example .env >nul
    )
)

echo ==========================================================
if "%APP_LANG%"=="EN" echo   🚀 STARTING DOCKER ENVIRONMENT (BALLOT BOX)
if "%APP_LANG%"=="ES" echo   🚀 INICIANDO ENTORNO DOCKER (URNA ELECTRÓNICA)
if "%APP_LANG%"=="IT" echo   🚀 AVVIO AMBIENTE DOCKER (URNA ELETTRONICA)
if "%APP_LANG%"=="PT" echo   🚀 INICIANDO AMBIENTE DOCKER (URNA ELETRÔNICA)
echo ==========================================================

docker compose up -d --build

if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" echo [ERROR] Failed to start Docker containers. Make sure Docker Desktop is running.
    if "%APP_LANG%"=="ES" echo [ERROR] Error al iniciar contenedores. Asegurate de que Docker Desktop este abierto.
    if "%APP_LANG%"=="IT" echo [ERRORE] Impossibile avviare i container. Verifica che Docker Desktop sia attivo.
    if "%APP_LANG%"=="PT" echo [ERRO] Falha ao iniciar containers Docker. Certifique-se de que o Docker Desktop esta aberto.
    pause
    exit /b %ERRORLEVEL%
)

echo.
if "%APP_LANG%"=="EN" (
    echo ✔ Containers started successfully!
    echo    👉 Voting Booth:     http://localhost:8080/frontend/index.html
    echo    👉 Live Results:     http://localhost:8080/frontend/apuracao.html
    echo    👉 RESTful API:      http://localhost:8080/backend/apuracao
    echo    👉 phpMyAdmin (DB):  http://localhost:8081
    echo.
    echo To view logs run: docker compose logs -f
    echo To stop services run: stop.bat
) else if "%APP_LANG%"=="ES" (
    echo ✔ ¡Contenedores iniciados con éxito!
    echo    👉 Cabina de Votación: http://localhost:8080/frontend/index.html
    echo    👉 Escrutinio en Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
    echo    👉 phpMyAdmin (BD):    http://localhost:8081
    echo.
    echo Para ver los logs ejecuta: docker compose logs -f
    echo Para detener servicios ejecuta: stop.bat
) else if "%APP_LANG%"=="IT" (
    echo ✔ Container avviati con successo!
    echo    👉 Cabina Elettorale:  http://localhost:8080/frontend/index.html
    echo    👉 Scrutinio dal Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
    echo    👉 phpMyAdmin (DB):    http://localhost:8081
    echo.
    echo Per visualizzare i log: docker compose logs -f
    echo Per arrestare i servizi: stop.bat
) else (
    echo ✔ Containers iniciados com sucesso!
    echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
    echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
    echo    👉 phpMyAdmin (DB):  http://localhost:8081
    echo.
    echo Para visualizar os logs execute: docker compose logs -f
    echo Para parar os servicos execute: stop.bat
)
echo ==========================================================
pause
