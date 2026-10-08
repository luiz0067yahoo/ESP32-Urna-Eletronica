@echo off
REM ==============================================================================
REM DESTROY KUBERNETES DEPLOYMENT (WINDOWS)
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
if "%APP_LANG%"=="EN" echo Removing all Kubernetes resources for 'urna-eletronica'...
if "%APP_LANG%"=="ES" echo Eliminando todos los recursos de Kubernetes para 'urna-eletronica'...
if "%APP_LANG%"=="IT" echo Rimozione di tutte le risorse Kubernetes per 'urna-eletronica'...
if "%APP_LANG%"=="PT" echo Removendo todos os recursos do Kubernetes no namespace 'urna-eletronica'...

kubectl delete -k . --ignore-not-found=true

if "%APP_LANG%"=="EN" echo ✔ All resources removed successfully.
if "%APP_LANG%"=="ES" echo ✔ Todos los recursos eliminados con éxito.
if "%APP_LANG%"=="IT" echo ✔ Tutte le risorse rimosse con successo.
if "%APP_LANG%"=="PT" echo ✔ Todos os recursos foram removidos com sucesso.
pause
