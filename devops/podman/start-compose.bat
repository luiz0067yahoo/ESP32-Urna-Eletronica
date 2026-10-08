@echo off
cd /d "%~dp0"

if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
    )
)

echo ==========================================================
echo   🚀 INICIANDO COM PODMAN COMPOSE (WINDOWS)
echo ==========================================================

podman-compose -f podman-compose.yml up -d --build

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Falha ao iniciar com podman-compose. Verifique se o Podman Desktop / WSL esta ativo.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ✔ Servicos iniciados com sucesso!
echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
echo.
pause
