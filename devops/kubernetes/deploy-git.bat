@echo off
REM ==============================================================================
REM DEPLOY AUTOMÁTICO VIA GIT (WINDOWS) - KUBERNETES
REM ==============================================================================

set BRANCH=%1
if "%BRANCH%"=="" set BRANCH=main

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
echo   ☸️ DEPLOY AUTOMÁTICO VIA GIT (KUBERNETES) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

echo 1. Atualizando codigo do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

echo 2. Construindo imagem Docker...
docker build -t urna-app:latest -f "%PROJECT_ROOT%\devops\docker\Dockerfile" "%PROJECT_ROOT%"

echo 3. Aplicando manifestos Kubernetes com Kustomize...
kubectl apply -k "%~dp0"

echo 4. Reiniciando deployment da aplicacao...
kubectl rollout restart deployment/urna-app -n urna-eletronica

echo 5. Aguardando conclusao do rollout...
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo.
echo ✔ Deploy via Git no Kubernetes finalizado com sucesso!
kubectl get pods -n urna-eletronica
echo ==========================================================
pause
