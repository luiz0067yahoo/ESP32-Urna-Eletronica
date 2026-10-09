@echo off
REM ==============================================================================
REM AUTOMATED GIT DEPLOY (WINDOWS) - DOCKER
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

set BRANCH=main

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
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
if "%APP_LANG%"=="EN" echo   🚀 AUTOMATED GIT DEPLOY (DOCKER) - BRANCH: %BRANCH%
if "%APP_LANG%"=="ES" echo   🚀 DESPLIEGUE AUTOMÁTICO VÍA GIT (DOCKER) - RAMA: %BRANCH%
if "%APP_LANG%"=="IT" echo   🚀 DEPLOY AUTOMATICO VIA GIT (DOCKER) - BRANCH: %BRANCH%
if "%APP_LANG%"=="PT" echo   🚀 DEPLOY AUTOMÁTICO VIA GIT (DOCKER) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 1. Fetching Git updates...
if "%APP_LANG%"=="ES" echo 1. Obteniendo actualizaciones de Git...
if "%APP_LANG%"=="IT" echo 1. Recupero aggiornamenti da Git...
if "%APP_LANG%"=="PT" echo 1. Buscando atualizacoes do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

if not exist "%PROJECT_ROOT%\.env" (
    if exist "%PROJECT_ROOT%\.env.example" (
        copy "%PROJECT_ROOT%\.env.example" "%PROJECT_ROOT%\.env" >nul
    )
)

if "%APP_LANG%"=="EN" echo 2. Updating Docker containers...
if "%APP_LANG%"=="ES" echo 2. Actualizando contenedores Docker...
if "%APP_LANG%"=="IT" echo 2. Aggiornamento container Docker...
if "%APP_LANG%"=="PT" echo 2. Atualizando containers Docker...
docker compose --env-file "%PROJECT_ROOT%\.env" up -d --build --remove-orphans

if %ERRORLEVEL% NEQ 0 (
    if "%APP_LANG%"=="EN" echo [ERROR] Failed to update Docker containers.
    if "%APP_LANG%"=="ES" echo [ERROR] Error al actualizar contenedores.
    if "%APP_LANG%"=="IT" echo [ERRORE] Impossibile aggiornare i container.
    if "%APP_LANG%"=="PT" echo [ERRO] Falha ao atualizar containers Docker.
    pause
    exit /b %ERRORLEVEL%
)

if "%APP_LANG%"=="EN" echo 3. Running DB migrations via PHP...
if "%APP_LANG%"=="ES" echo 3. Ejecutando migraciones de BD vía PHP...
if "%APP_LANG%"=="IT" echo 3. Esecuzione migrazioni DB tramite PHP...
if "%APP_LANG%"=="PT" echo 3. Executando migracoes do banco via PHP...
timeout /t 5 /nobreak >nul
docker compose exec -T app php db/install.php

if "%APP_LANG%"=="EN" echo 4. Pruning unused images...
if "%APP_LANG%"=="ES" echo 4. Limpiando imágenes en desuso...
if "%APP_LANG%"=="IT" echo 4. Rimozione immagini inutilizzate...
if "%APP_LANG%"=="PT" echo 4. Limpando imagens antigas...
docker image prune -f

echo.
if "%APP_LANG%"=="EN" echo ✔ Git Deploy completed successfully!
if "%APP_LANG%"=="ES" echo ✔ ¡Despliegue Git completado con éxito!
if "%APP_LANG%"=="IT" echo ✔ Deploy Git completato con successo!
if "%APP_LANG%"=="PT" echo ✔ Deploy via Git concluido com sucesso!
docker compose ps
echo ==========================================================
pause
