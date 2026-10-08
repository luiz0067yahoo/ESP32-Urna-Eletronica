@echo off
REM ==============================================================================
REM AUTOMATED GIT DEPLOY (WINDOWS) - PODMAN
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
if "%APP_LANG%"=="EN" echo   🚀 AUTOMATED GIT DEPLOY (PODMAN) - BRANCH: %BRANCH%
if "%APP_LANG%"=="ES" echo   🚀 DESPLIEGUE AUTOMÁTICO VÍA GIT (PODMAN) - RAMA: %BRANCH%
if "%APP_LANG%"=="IT" echo   🚀 DEPLOY AUTOMATICO VIA GIT (PODMAN) - BRANCH: %BRANCH%
if "%APP_LANG%"=="PT" echo   🚀 DEPLOY AUTOMÁTICO VIA GIT (PODMAN) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 1. Fetching Git updates...
if "%APP_LANG%"=="ES" echo 1. Obteniendo actualizaciones de Git...
if "%APP_LANG%"=="IT" echo 1. Recupero aggiornamenti da Git...
if "%APP_LANG%"=="PT" echo 1. Atualizando codigo do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

cd /d "%~dp0"
if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
    )
)

if "%APP_LANG%"=="EN" echo 2. Rebuilding and updating Podman containers...
if "%APP_LANG%"=="ES" echo 2. Reconstruyendo y actualizando contenedores Podman...
if "%APP_LANG%"=="IT" echo 2. Ricostruzione e aggiornamento container Podman...
if "%APP_LANG%"=="PT" echo 2. Atualizando containers Podman...
where podman-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    podman-compose -f podman-compose.yml up -d --build
    timeout /t 5 /nobreak >nul
    podman exec urna_podman_app php db/install.php
) else (
    call start-pod.bat %APP_LANG%
    timeout /t 5 /nobreak >nul
    podman exec urna-app php db/install.php
)

if "%APP_LANG%"=="EN" echo 3. Pruning unused images...
if "%APP_LANG%"=="ES" echo 3. Limpiando imágenes antiguas...
if "%APP_LANG%"=="IT" echo 3. Rimozione immagini inutilizzate...
if "%APP_LANG%"=="PT" echo 3. Limpando imagens antigas...
podman image prune -f

echo.
if "%APP_LANG%"=="EN" echo ✔ Git Deploy on Podman finished!
if "%APP_LANG%"=="ES" echo ✔ ¡Despliegue Git en Podman finalizado!
if "%APP_LANG%"=="IT" echo ✔ Deploy Git su Podman completato!
if "%APP_LANG%"=="PT" echo ✔ Deploy via Git no Podman finalizado!
echo ==========================================================
pause
