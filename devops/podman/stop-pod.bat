@echo off
REM ==============================================================================
REM PODMAN STOP POD (WINDOWS)
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"

set POD_NAME=urna-pod

if /i "%~1"=="en" (set APP_LANG=EN& goto RUN)
if /i "%~1"=="pt" (set APP_LANG=PT& goto RUN)
if /i "%~1"=="es" (set APP_LANG=ES& goto RUN)
if /i "%~1"=="it" (set APP_LANG=IT& goto RUN)

echo  Select Language / Selecione o Idioma / Seleccione / Seleziona:
echo   [1] 🇺🇸 English (Default)
echo   [2] 🇧🇷 Português
echo   [3] 🇪🇸 Español
echo   [4] 🇮🇹 Italiano
set /p LANG_CHOICE="Choice [1-4] (Press ENTER for English): "
if "%LANG_CHOICE%"=="" set LANG_CHOICE=1
if "%LANG_CHOICE%"=="2" (set APP_LANG=PT) else if "%LANG_CHOICE%"=="3" (set APP_LANG=ES) else if "%LANG_CHOICE%"=="4" (set APP_LANG=IT) else (set APP_LANG=EN)

:RUN
if "%APP_LANG%"=="EN" echo Stopping and removing Podman Pod '%POD_NAME%'...
if "%APP_LANG%"=="ES" echo Deteniendo y eliminando Podman Pod '%POD_NAME%'...
if "%APP_LANG%"=="IT" echo Arresto e rimozione Podman Pod '%POD_NAME%'...
if "%APP_LANG%"=="PT" echo Parando e removendo Podman Pod '%POD_NAME%'...

podman pod rm -f %POD_NAME% 2>nul

if "%APP_LANG%"=="EN" echo ✔ Pod '%POD_NAME%' stopped successfully.
if "%APP_LANG%"=="ES" echo ✔ Pod '%POD_NAME%' detenido con éxito.
if "%APP_LANG%"=="IT" echo ✔ Pod '%POD_NAME%' arrestato con successo.
if "%APP_LANG%"=="PT" echo ✔ Pod '%POD_NAME%' finalizado com sucesso.
pause
