@echo off
REM ==============================================================================
REM PODMAN STOP COMPOSE (WINDOWS)
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"

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
if "%APP_LANG%"=="EN" echo Stopping Podman Compose services...
if "%APP_LANG%"=="ES" echo Deteniendo servicios de Podman Compose...
if "%APP_LANG%"=="IT" echo Arresto dei servizi Podman Compose...
if "%APP_LANG%"=="PT" echo Parando servicos do Podman Compose...

where podman-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    podman-compose -f podman-compose.yml down
) else (
    podman compose -f podman-compose.yml down
)

if "%APP_LANG%"=="EN" echo ✔ Services stopped.
if "%APP_LANG%"=="ES" echo ✔ Servicios detenidos.
if "%APP_LANG%"=="IT" echo ✔ Servizi arrestati.
if "%APP_LANG%"=="PT" echo ✔ Servicos finalizados.
pause
