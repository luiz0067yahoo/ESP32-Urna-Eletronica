@echo off
REM ==============================================================================
REM DEPLOY AUTOMÁTICO VIA GIT (WINDOWS) - DOCKER
REM ==============================================================================

set BRANCH=%1
if "%BRANCH%"=="" set BRANCH=main

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
echo   🚀 DEPLOY AUTOMÁTICO VIA GIT (DOCKER) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

echo 1. Buscando atualizacoes do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

cd /d "%~dp0"
if not exist .env (
    if exist .env.example (
        echo 2. Criando .env a partir de .env.example...
        copy .env.example .env >nul
    )
)

echo 3. Atualizando containers Docker...
docker compose up -d --build --remove-orphans

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao atualizar containers Docker.
    pause
    exit /b %ERRORLEVEL%
)

echo 4. Executando migracoes do banco...
timeout /t 5 /nobreak >nul
docker compose exec -T app php db/install.php

echo 5. Limpando imagens antigas...
docker image prune -f

echo.
echo ✔ Deploy via Git concluido com sucesso!
docker compose ps
echo ==========================================================
pause
