@echo off
REM ==============================================================================
REM AUTOMATED GIT DEPLOY (WINDOWS) - KUBERNETES
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
if "%APP_LANG%"=="EN" echo   ☸️ AUTOMATED GIT DEPLOY (KUBERNETES) - BRANCH: %BRANCH%
if "%APP_LANG%"=="ES" echo   ☸️ DESPLIEGUE AUTOMÁTICO VÍA GIT (KUBERNETES) - RAMA: %BRANCH%
if "%APP_LANG%"=="IT" echo   ☸️ DEPLOY AUTOMATICO VIA GIT (KUBERNETES) - BRANCH: %BRANCH%
if "%APP_LANG%"=="PT" echo   ☸️ DEPLOY AUTOMÁTICO VIA GIT (KUBERNETES) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 1. Fetching Git updates...
if "%APP_LANG%"=="ES" echo 1. Obteniendo actualizaciones de Git...
if "%APP_LANG%"=="IT" echo 1. Recupero aggiornamenti da Git...
if "%APP_LANG%"=="PT" echo 1. Atualizando codigo do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

if "%APP_LANG%"=="EN" echo 2. Building Docker image...
if "%APP_LANG%"=="ES" echo 2. Construyendo imagen Docker...
if "%APP_LANG%"=="IT" echo 2. Compilazione immagine Docker...
if "%APP_LANG%"=="PT" echo 2. Construindo imagem Docker...
docker build -t urna-app:latest -f "%PROJECT_ROOT%\devops\docker\Dockerfile" "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 3. Applying Kubernetes manifests with Kustomize...
if "%APP_LANG%"=="ES" echo 3. Aplicando manifiestos Kubernetes con Kustomize...
if "%APP_LANG%"=="IT" echo 3. Applicazione manifesti Kubernetes con Kustomize...
if "%APP_LANG%"=="PT" echo 3. Aplicando manifestos Kubernetes com Kustomize...
kubectl apply -k "%~dp0"

if "%APP_LANG%"=="EN" echo 4. Restarting deployment...
if "%APP_LANG%"=="ES" echo 4. Reiniciando despliegue...
if "%APP_LANG%"=="IT" echo 4. Riavvio deployment...
if "%APP_LANG%"=="PT" echo 4. Reiniciando deployment da aplicacao...
kubectl rollout restart deployment/urna-app -n urna-eletronica

if "%APP_LANG%"=="EN" echo 5. Waiting for rollout completion...
if "%APP_LANG%"=="ES" echo 5. Esperando finalización del rollout...
if "%APP_LANG%"=="IT" echo 5. Attesa completamento rollout...
if "%APP_LANG%"=="PT" echo 5. Aguardando conclusao do rollout...
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo.
if "%APP_LANG%"=="EN" echo ✔ Git Deploy on Kubernetes finished successfully!
if "%APP_LANG%"=="ES" echo ✔ ¡Despliegue Git en Kubernetes finalizado con éxito!
if "%APP_LANG%"=="IT" echo ✔ Deploy Git su Kubernetes completato con successo!
if "%APP_LANG%"=="PT" echo ✔ Deploy via Git no Kubernetes finalizado com sucesso!
kubectl get pods -n urna-eletronica
echo ==========================================================
pause
