@echo off
REM ==============================================================================
REM NATIVE LAUNCHER (WINDOWS) - POKÉMON ELECTRONIC VOTING MACHINE (WITHOUT DOCKER)
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%..\.."
set "PROJECT_ROOT=%CD%"
popd
set "PORT=8080"
set "DB_NAME=urna_eletronica"

if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

echo ===================================================================
echo   POKÉMON ELECTRONIC VOTING MACHINE - NATIVE HOST LAUNCHER
echo ===================================================================
echo  Select Language / Selecione o Idioma / Seleccione / Seleziona:
echo   [1] 🇺🇸 English (Default)
echo   [2] 🇧🇷 Português
echo   [3] 🇪🇸 Español
echo   [4] 🇮🇹 Italiano
set /p LANG_CHOICE="Choice [1-4] (Press ENTER for English): "
if "%LANG_CHOICE%"=="" set LANG_CHOICE=1
if "%LANG_CHOICE%"=="2" (set APP_LANG=PT) else if "%LANG_CHOICE%"=="3" (set APP_LANG=ES) else if "%LANG_CHOICE%"=="4" (set APP_LANG=IT) else (set APP_LANG=EN)

:RUN
if exist "%SCRIPT_DIR%ENV" (
    for /f "usebackq tokens=1,* delims==" %%A in ("%SCRIPT_DIR%ENV") do (
        set "k=%%A"
        if not "!k:~0,1!"=="#" (
            if /i "%%A"=="PORT" set "PORT=%%B"
        )
    )
)

echo ===================================================================
if "%APP_LANG%"=="EN" echo   POKÉMON BALLOT BOX - NATIVE LAUNCH (WITHOUT DOCKER)
if "%APP_LANG%"=="ES" echo   URNA ELECTRÓNICA POKÉMON - INICIO NATIVO (SIN DOCKER)
if "%APP_LANG%"=="IT" echo   URNA ELETTRONICA POKÉMON - AVVIO NATIVO (SENZA DOCKER)
if "%APP_LANG%"=="PT" echo   URNA ELETRÔNICA POKÉMON - INICIALIZAÇÃO NATIVA (SEM DOCKER)
echo ===================================================================

if "%APP_LANG%"=="EN" echo 1. Checking local MySQL database...
if "%APP_LANG%"=="ES" echo 1. Verificando base de datos MySQL local...
if "%APP_LANG%"=="IT" echo 1. Verifica database MySQL locale...
if "%APP_LANG%"=="PT" echo 1. Verificando banco de dados MySQL local...
call "%SCRIPT_DIR%setup_db.bat" %APP_LANG% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    if "%APP_LANG%"=="EN" echo    -> Database ready!
    if "%APP_LANG%"=="ES" echo    -> ¡Base de datos lista!
    if "%APP_LANG%"=="IT" echo    -> Database pronto!
    if "%APP_LANG%"=="PT" echo    -> Banco de dados pronto!
) else (
    if "%APP_LANG%"=="EN" echo    -> Ensure MySQL/XAMPP is started.
    if "%APP_LANG%"=="ES" echo    -> Asegúrate de que MySQL/XAMPP esté iniciado.
    if "%APP_LANG%"=="IT" echo    -> Assicurati che MySQL/XAMPP sia avviato.
    if "%APP_LANG%"=="PT" echo    -> Certifique-se de que o MySQL/XAMPP esta iniciado.
)

echo.
if "%APP_LANG%"=="EN" echo 2. Starting PHP Web Server on port %PORT%...
if "%APP_LANG%"=="ES" echo 2. Iniciando Servidor Web PHP en el puerto %PORT%...
if "%APP_LANG%"=="IT" echo 2. Avvio Server Web PHP sulla porta %PORT%...
if "%APP_LANG%"=="PT" echo 2. Iniciando Servidor Web PHP na porta %PORT%...
echo.
echo    Urna/Booth:  http://localhost:%PORT%/frontend/index.html
echo    Results:     http://localhost:%PORT%/frontend/apuracao.html
echo    RESTful API: http://localhost:%PORT%/backend/apuracao
echo.
if "%APP_LANG%"=="EN" echo Press Ctrl+C to terminate server.
if "%APP_LANG%"=="ES" echo Presione Ctrl+C para detener el servidor.
if "%APP_LANG%"=="IT" echo Premi Ctrl+C per terminare il server.
if "%APP_LANG%"=="PT" echo Pressione Ctrl+C para encerrar o servidor.
echo ===================================================================

cd /d "%PROJECT_ROOT%"
start "" "http://localhost:%PORT%/frontend/index.html"
php -S 0.0.0.0:%PORT%
