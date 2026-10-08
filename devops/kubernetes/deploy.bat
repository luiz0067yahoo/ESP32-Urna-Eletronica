@echo off
REM ==============================================================================
REM DEPLOY KUBERNETES (WINDOWS) - URNA ELETRÔNICA POKÉMON
REM ==============================================================================

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
echo   ☸️ DEPLOY KUBERNETES - URNA ELETRÔNICA POKÉMON
echo ==========================================================

where kubectl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] 'kubectl' nao foi encontrado no PATH.
    pause
    exit /b 1
)

echo 1. Construindo imagem local urna-app:latest...
docker build -t urna-app:latest -f "%PROJECT_ROOT%\devops\docker\Dockerfile" "%PROJECT_ROOT%"

echo 2. Aplicando manifestos Kubernetes com Kustomize...
kubectl apply -k .

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao aplicar manifestos no cluster Kubernetes.
    pause
    exit /b %ERRORLEVEL%
)

echo 3. Aguardando banco de dados ficar pronto...
kubectl rollout status deployment/urna-db -n urna-eletronica --timeout=120s

echo 4. Aguardando aplicacao ficar pronta...
kubectl rollout status deployment/urna-app -n urna-eletronica --timeout=180s

echo.
echo ✔ Deploy realizado com sucesso no namespace 'urna-eletronica'!
echo.
echo 📋 Como acessar a aplicação:
echo    Opção 1: Via NodePort na porta 30080:
echo       http://localhost:30080/frontend/index.html
echo.
echo    Opção 2: Via Port-Forward:
echo       kubectl port-forward svc/urna-app-service 8080:80 -n urna-eletronica
echo       Em seguida acesse: http://localhost:8080/frontend/index.html
echo.
echo Para verificar os pods: kubectl get pods -n urna-eletronica
echo Para remover tudo: destroy.bat
echo ==========================================================
pause
