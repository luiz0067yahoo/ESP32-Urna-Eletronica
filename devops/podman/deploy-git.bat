@echo off
REM ==============================================================================
REM DEPLOY AUTOMÁTICO VIA GIT (WINDOWS) - PODMAN
REM ==============================================================================

set BRANCH=%1
if "%BRANCH%"=="" set BRANCH=main

cd /d "%~dp0"
pushd ..\..
set "PROJECT_ROOT=%CD%"
popd

echo ==========================================================
echo   🚀 DEPLOY AUTOMÁTICO VIA GIT (PODMAN) - BRANCH: %BRANCH%
echo ==========================================================

cd /d "%PROJECT_ROOT%"

echo 1. Atualizando codigo do Git...
git fetch origin %BRANCH%
git reset --hard origin/%BRANCH%

cd /d "%~dp0"
if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
    )
)

echo 2. Atualizando containers Podman...
where podman-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    podman-compose -f podman-compose.yml up -d --build
    timeout /t 5 /nobreak >nul
    podman exec urna_podman_app php db/install.php
) else (
    call start-pod.bat
    timeout /t 5 /nobreak >nul
    podman exec urna-app php db/install.php
)

echo 3. Limpando imagens antigas...
podman image prune -f

echo.
echo ✔ Deploy via Git no Podman finalizado!
echo ==========================================================
pause
