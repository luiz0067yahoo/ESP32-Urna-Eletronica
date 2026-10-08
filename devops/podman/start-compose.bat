@echo off
REM ==============================================================================
REM PODMAN COMPOSE LAUNCHER (WINDOWS)
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

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
        copy .env.example .env >nul
    )
)

echo ==========================================================
if "%APP_LANG%"=="EN" echo   🚀 STARTING WITH PODMAN COMPOSE
if "%APP_LANG%"=="ES" echo   🚀 INICIANDO CON PODMAN COMPOSE
if "%APP_LANG%"=="IT" echo   🚀 AVVIO CON PODMAN COMPOSE
if "%APP_LANG%"=="PT" echo   🚀 INICIANDO COM PODMAN COMPOSE
echo ==========================================================

where podman-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    podman-compose -f podman-compose.yml up -d --build
) else (
    podman compose -f podman-compose.yml up -d --build
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    if "%APP_LANG%"=="EN" echo [ERROR] Failed to start with podman-compose. Verify Podman Desktop is running.
    if "%APP_LANG%"=="ES" echo [ERROR] Error al iniciar con podman-compose. Verifica que Podman Desktop esté activo.
    if "%APP_LANG%"=="IT" echo [ERRORE] Impossibile avviare con podman-compose. Verifica che Podman Desktop sia attivo.
    if "%APP_LANG%"=="PT" echo [ERRO] Falha ao iniciar com podman-compose. Verifique se o Podman Desktop esta ativo.
    pause
    exit /b %ERRORLEVEL%
)

echo.
if "%APP_LANG%"=="EN" (
    echo ✔ Services started successfully!
    echo    👉 Voting Booth: http://localhost:8080/frontend/index.html
    echo    👉 Live Results: http://localhost:8080/frontend/apuracao.html
    echo    👉 RESTful API:  http://localhost:8080/backend/apuracao
) else if "%APP_LANG%"=="ES" (
    echo ✔ ¡Servicios iniciados con éxito!
    echo    👉 Cabina de Votación: http://localhost:8080/frontend/index.html
    echo    👉 Escrutinio en Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
) else if "%APP_LANG%"=="IT" (
    echo ✔ Servizi avviati con successo!
    echo    👉 Cabina Elettorale:  http://localhost:8080/frontend/index.html
    echo    👉 Scrutinio dal Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend:   http://localhost:8080/backend/apuracao
) else (
    echo ✔ Servicos iniciados com sucesso!
    echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
    echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
    echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
)
echo.
pause
