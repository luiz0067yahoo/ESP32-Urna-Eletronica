@echo off
REM ==============================================================================
REM INICIALIZADOR DOCKER (WINDOWS) - URNA ELETRÔNICA POKÉMON
REM ==============================================================================

cd /d "%~dp0"

if not exist .env (
    if exist .env.example (
        echo Criando arquivo .env a partir de .env.example...
        copy .env.example .env >nul
    )
)

echo ==========================================================
echo   🚀 INICIANDO AMBIENTE DOCKER (URNA ELETRÔNICA)
echo ==========================================================

docker compose up -d --build

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Falha ao iniciar containers Docker. Certifique-se de que o Docker Desktop esta aberto.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ✔ Containers iniciados com sucesso!
echo    👉 Urna Eletrônica:  http://localhost:8080/frontend/index.html
echo    👉 Apuração ao Vivo: http://localhost:8080/frontend/apuracao.html
echo    👉 API REST Backend: http://localhost:8080/backend/apuracao
echo    👉 phpMyAdmin (DB):  http://localhost:8081
echo.
echo Para visualizar os logs execute: docker compose logs -f
echo Para parar os servicos execute: stop.bat
echo ==========================================================
pause
