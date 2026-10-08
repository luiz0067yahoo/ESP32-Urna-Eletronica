@echo off
REM ==============================================================================
REM MYSQL SETUP & MIGRATION (WINDOWS) - WITHOUT DOCKER
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

setlocal enabledelayedexpansion
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%..\.."
set "PROJECT_ROOT=%CD%\"
popd

if /i "%~1"=="en" (set APP_LANG=EN)
if /i "%~1"=="pt" (set APP_LANG=PT)
if /i "%~1"=="es" (set APP_LANG=ES)
if /i "%~1"=="it" (set APP_LANG=IT)
if not defined APP_LANG set APP_LANG=EN

set "ENV_FILE=%PROJECT_ROOT%backend\.env"
if not exist "%ENV_FILE%" (
    if exist "%PROJECT_ROOT%backend\.env.example" (
        set "ENV_FILE=%PROJECT_ROOT%backend\.env.example"
    )
)

if exist "%ENV_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
        set "key=%%A"
        if not "!key:~0,1!"=="#" (
            set "%%A=%%B"
        )
    )
)

if "%DB_USER%"=="" set "DB_USER=root"
if "%DB_HOST%"=="" set "DB_HOST=localhost"
if "%DB_NAME%"=="" set "DB_NAME=urna_eletronica"

echo ===================================================================
if "%APP_LANG%"=="EN" echo [DEVOPS] Provisioning MySQL Database: %DB_NAME% (Without Docker)
if "%APP_LANG%"=="ES" echo [DEVOPS] Aprovisionando Base de Datos MySQL: %DB_NAME% (Sin Docker)
if "%APP_LANG%"=="IT" echo [DEVOPS] Provisioning Database MySQL: %DB_NAME% (Senza Docker)
if "%APP_LANG%"=="PT" echo [DEVOPS] Provisionando Banco de Dados MySQL: %DB_NAME% (Sem Docker)
echo ===================================================================

set "MYSQL_CMD=mysql -u %DB_USER% -h %DB_HOST%"
if not "%DB_PASS%"=="" set "MYSQL_CMD=%MYSQL_CMD% -p%DB_PASS%"

if "%APP_LANG%"=="EN" echo 1. Creating database %DB_NAME%...
if "%APP_LANG%"=="ES" echo 1. Creando base de datos %DB_NAME%...
if "%APP_LANG%"=="IT" echo 1. Creazione database %DB_NAME%...
if "%APP_LANG%"=="PT" echo 1. Criando banco de dados %DB_NAME%...
%MYSQL_CMD% -e "CREATE DATABASE IF NOT EXISTS \`%DB_NAME%\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1

if "%APP_LANG%"=="EN" echo 2. Running smart installer via PHP: db\install.php...
if "%APP_LANG%"=="ES" echo 2. Ejecutando instalador inteligente vía PHP: db\install.php...
if "%APP_LANG%"=="IT" echo 2. Esecuzione installer intelligente tramite PHP: db\install.php...
if "%APP_LANG%"=="PT" echo 2. Executando instalador inteligente: db\install.php...
php "%PROJECT_ROOT%db\install.php"

echo.
if "%APP_LANG%"=="EN" echo [SUCCESS] Database %DB_NAME% verified and ready!
if "%APP_LANG%"=="ES" echo [ÉXITO] ¡Base de datos %DB_NAME% verificada y lista!
if "%APP_LANG%"=="IT" echo [SUCCESSO] Database %DB_NAME% verificato e pronto!
if "%APP_LANG%"=="PT" echo [SUCESSO] Banco de dados %DB_NAME% verificado e configurado com sucesso!
exit /b 0
