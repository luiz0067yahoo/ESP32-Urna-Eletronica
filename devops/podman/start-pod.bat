@echo off
REM ==============================================================================
REM INICIALIZAÇÃO NATIVA DE POD COM PODMAN (WINDOWS)
REM ==============================================================================

set POD_NAME=urna-pod
set APP_IMAGE=urna-app:podman

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
echo   🚀 INICIANDO POD NATIVO PODMAN (%POD_NAME%)
echo ==========================================================

podman pod rm -f %POD_NAME% 2>nul

echo 1. Criando Pod '%POD_NAME%' com porta 8080...
podman pod create --name %POD_NAME% -p 8080:80

echo 2. Subindo MariaDB no Pod...
podman run -d --name urna-db --pod %POD_NAME% --restart unless-stopped -e MYSQL_DATABASE=urna -e MYSQL_USER=urna -e MYSQL_PASSWORD=urna123 -e MYSQL_ROOT_PASSWORD=rootpassword -v urna_pod_db_data:/var/lib/mysql:Z docker.io/library/mariadb:10.11

echo 3. Construindo imagem %APP_IMAGE%...
podman build -t %APP_IMAGE% -f Containerfile "%PROJECT_ROOT%"

echo 4. Subindo aplicacao Urna no Pod...
podman run -d --name urna-app --pod %POD_NAME% --restart unless-stopped -e DB_HOST=127.0.0.1 -e DB_PORT=3306 -e DB_NAME=urna -e DB_USER=urna -e DB_PASS=urna123 %APP_IMAGE%

echo.
echo ✔ Podman Pod '%POD_NAME%' iniciado com sucesso!
echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
echo.
pause
