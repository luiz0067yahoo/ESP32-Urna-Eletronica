@echo off
REM ==============================================================================
REM KUBERNETES DEPLOY (WINDOWS) - POKÉMON ELECTRONIC VOTING MACHINE
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

echo ==========================================================
echo   ☸️ KUBERNETES DEPLOY LAUNCHER
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

echo ==========================================================
if "%APP_LANG%"=="EN" echo   ☸️ KUBERNETES DEPLOY - POKÉMON ELECTRONIC VOTING MACHINE
if "%APP_LANG%"=="ES" echo   ☸️ DESPLIEGUE EN KUBERNETES - URNA ELECTRÓNICA POKÉMON
if "%APP_LANG%"=="IT" echo   ☸️ DEPLOY KUBERNETES - URNA ELETTRONICA POKÉMON
if "%APP_LANG%"=="PT" echo   ☸️ DEPLOY KUBERNETES - URNA ELETRÔNICA POKÉMON
echo ==========================================================

where kubectl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if "%APP_LANG%"=="EN" echo [ERROR] 'kubectl' was not found in PATH.
    if "%APP_LANG%"=="ES" echo [ERROR] 'kubectl' no fue encontrado en PATH.
    if "%APP_LANG%"=="IT" echo [ERRORE] 'kubectl' non è stato trovato nel PATH.
    if "%APP_LANG%"=="PT" echo [ERRO] 'kubectl' nao foi encontrado no PATH.
    pause
    exit /b 1
)

if "%APP_LANG%"=="EN" echo 1. Building local container image urna-app:latest...
if "%APP_LANG%"=="ES" echo 1. Construyendo imagen local urna-app:latest...
if "%APP_LANG%"=="IT" echo 1. Compilazione immagine locale urna-app:latest...
if "%APP_LANG%"=="PT" echo 1. Construindo imagem local urna-app:latest...
docker build -t urna-app:latest -f "%PROJECT_ROOT%\devops\docker\Dockerfile" "%PROJECT_ROOT%"

if "%APP_LANG%"=="EN" echo 2. Applying Kubernetes manifests with Kustomize...
if "%APP_LANG%"=="ES" echo 2. Aplicando manifiestos Kubernetes con Kustomize...
if "%APP_LANG%"=="IT" echo 2. Applicazione manifesti Kubernetes con Kustomize...
if "%APP_LANG%"=="PT" echo 2. Aplicando manifestos Kubernetes com Kustomize...
kubectl apply -k .

if %ERRORLEVEL% NEQ 0 (
    if "%APP_LANG%"=="EN" echo [ERROR] Failed to apply manifests to Kubernetes cluster.
    if "%APP_LANG%"=="ES" echo [ERROR] Error al aplicar manifiestos en el clúster.
    if "%APP_LANG%"=="IT" echo [ERRORE] Impossibile applicare i manifesti nel cluster.
    if "%APP_LANG%"=="PT" echo [ERRO] Falha ao aplicar manifestos no cluster Kubernetes.
    pause
    exit /b %ERRORLEVEL%
)

if "%APP_LANG%"=="EN" echo 3. Waiting for database rollout...
if "%APP_LANG%"=="ES" echo 3. Esperando que la base de datos esté lista...
if "%APP_LANG%"=="IT" echo 3. Attesa disponibilità database...
if "%APP_LANG%"=="PT" echo 3. Aguardando banco de dados ficar pronto...
kubectl rollout status deployment/urna-db -n urna-eletronica --timeout=120s

if "%APP_LANG%"=="EN" echo 4. Waiting for application rollout...
if "%APP_LANG%"=="ES" echo 4. Esperando que la aplicación esté lista...
if "%APP_LANG%"=="IT" echo 4. Attesa disponibilità applicazione...
if "%APP_LANG%"=="PT" echo 4. Aguardando aplicacao ficar pronta...
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo.
if "%APP_LANG%"=="EN" (
    echo ✔ Deploy successful in namespace 'urna-eletronica'!
    echo 📋 How to access:
    echo    Option 1: Via NodePort on port 30080:
    echo       http://localhost:30080/frontend/index.html
    echo    Option 2: Via Port-Forward:
    echo       kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
    echo.
    echo Check pods: kubectl get pods -n urna-eletronica
    echo Remove all: destroy.bat
) else if "%APP_LANG%"=="ES" (
    echo ✔ ¡Despliegue exitoso en el namespace 'urna-eletronica'!
    echo 📋 Cómo acceder:
    echo    Opción 1: Vía NodePort en puerto 30080:
    echo       http://localhost:30080/frontend/index.html
    echo    Opción 2: Vía Port-Forward:
    echo       kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
    echo.
    echo Ver pods: kubectl get pods -n urna-eletronica
    echo Eliminar: destroy.bat
) else if "%APP_LANG%"=="IT" (
    echo ✔ Deploy completato con successo nel namespace 'urna-eletronica'!
    echo 📋 Come accedere:
    echo    Opzione 1: Tramite NodePort su porta 30080:
    echo       http://localhost:30080/frontend/index.html
    echo    Opzione 2: Tramite Port-Forward:
    echo       kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
    echo.
    echo Controlla pod: kubectl get pods -n urna-eletronica
    echo Rimuovi tutto: destroy.bat
) else (
    echo ✔ Deploy realizado com sucesso no namespace 'urna-eletronica'!
    echo 📋 Como acessar a aplicação:
    echo    Opção 1: Via NodePort na porta 30080:
    echo       http://localhost:30080/frontend/index.html
    echo    Opção 2: Via Port-Forward:
    echo       kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
    echo.
    echo Para verificar os pods: kubectl get pods -n urna-eletronica
    echo Para remover tudo: destroy.bat
)
echo ==========================================================
pause
