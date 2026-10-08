@echo off
REM ==============================================================================
REM DEVOPS UNIFIED LAUNCHER (WINDOWS) - POKÉMON ELECTRONIC VOTING MACHINE
REM Supports 4 Languages: English (Default), Português, Español, Italiano
REM ==============================================================================

chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

if /i "%~1"=="en" (set APP_LANG=EN& goto MENU)
if /i "%~1"=="pt" (set APP_LANG=PT& goto MENU)
if /i "%~1"=="es" (set APP_LANG=ES& goto MENU)
if /i "%~1"=="it" (set APP_LANG=IT& goto MENU)

:LANG_SELECT
cls
echo ==========================================================
echo   🛠️ DEVOPS UNIFIED LAUNCHER • POKÉMON BALLOT BOX
echo ==========================================================
echo  Select Language / Selecione o Idioma / Seleccione / Seleziona:
echo   [1] 🇺🇸 English (Default)
echo   [2] 🇧🇷 Português
echo   [3] 🇪🇸 Español
echo   [4] 🇮🇹 Italiano
echo ==========================================================
set /p LANG_CHOICE="Choice [1-4] (Press ENTER for English): "
if "%LANG_CHOICE%"=="" set LANG_CHOICE=1
if "%LANG_CHOICE%"=="2" (set APP_LANG=PT) else if "%LANG_CHOICE%"=="3" (set APP_LANG=ES) else if "%LANG_CHOICE%"=="4" (set APP_LANG=IT) else (set APP_LANG=EN)

:MENU
cls
echo ==========================================================
if "%APP_LANG%"=="EN" (
    echo   🛠️ DEVOPS CONTROL PANEL - POKÉMON BALLOT BOX
    echo ==========================================================
    echo.
    echo  Choose the DevOps environment to start:
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Pod          (Native Rootless Podman Pod)
    echo   [3] 🦭 Podman Compose      (Podman Compose stack)
    echo   [4] ☸️ Kubernetes          (Deploy manifests with Kustomize)
    echo   [5] ⚙️ Native Host         (PHP Built-in Server / Local MySQL)
    echo   [6] 🛑 Stop Docker
    echo   [7] 🛑 Stop Podman
    echo   [8] 🛑 Destroy Kubernetes Deployment
    echo   [9] 🌐 Change Language (EN / PT / ES / IT)
    echo   [0] ❌ Exit
    echo ==========================================================
    set /p OPCAO="Enter choice (0-9): "
) else if "%APP_LANG%"=="ES" (
    echo   🛠️ PANEL DE CONTROL DEVOPS - URNA ELECTRÓNICA
    echo ==========================================================
    echo.
    echo  Elige el entorno DevOps para iniciar:
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Pod          (Pod Nativo de Podman)
    echo   [3] 🦭 Podman Compose      (Pila de Podman Compose)
    echo   [4] ☸️ Kubernetes          (Despliegue con Kustomize)
    echo   [5] ⚙️ Host Nativo         (Servidor PHP Integrado / MySQL Local)
    echo   [6] 🛑 Detener Docker
    echo   [7] 🛑 Detener Podman
    echo   [8] 🛑 Eliminar Despliegue Kubernetes
    echo   [9] 🌐 Cambiar Idioma (EN / PT / ES / IT)
    echo   [0] ❌ Salir
    echo ==========================================================
    set /p OPCAO="Introduce opción (0-9): "
) else if "%APP_LANG%"=="IT" (
    echo   🛠️ PANNELLO DI CONTROLLO DEVOPS - URNA ELETTRONICA
    echo ==========================================================
    echo.
    echo  Scegli l'ambiente DevOps da avviare:
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Pod          (Pod Nativo Podman)
    echo   [3] 🦭 Podman Compose      (Stack Podman Compose)
    echo   [4] ☸️ Kubernetes          (Distribuzione con Kustomize)
    echo   [5] ⚙️ Host Nativo         (Server PHP Integrato / MySQL Locale)
    echo   [6] 🛑 Arresta Docker
    echo   [7] 🛑 Arresta Podman
    echo   [8] 🛑 Rimuovi Distribuzione Kubernetes
    echo   [9] 🌐 Cambia Lingua (EN / PT / ES / IT)
    echo   [0] ❌ Esci
    echo ==========================================================
    set /p OPCAO="Inserisci opzione (0-9): "
) else (
    echo   🛠️ PAINEL DE CONTROLE DEVOPS - URNA ELETRÔNICA
    echo ==========================================================
    echo.
    echo  Escolha o ambiente DevOps para inicializar:
    echo   [1] 🐳 Docker Compose      (Apache + PHP 8.2 + MariaDB + phpMyAdmin)
    echo   [2] 🦭 Podman Pod          (Pod Nativo do Podman)
    echo   [3] 🦭 Podman Compose      (Stack Podman Compose)
    echo   [4] ☸️ Kubernetes          (Deploy de Manifestos com Kustomize)
    echo   [5] ⚙️ Host Nativo         (Servidor PHP Embutido / MySQL Local)
    echo   [6] 🛑 Parar Docker
    echo   [7] 🛑 Parar Podman
    echo   [8] 🛑 Remover Deploy Kubernetes
    echo   [9] 🌐 Mudar Idioma (EN / PT / ES / IT)
    echo   [0] ❌ Sair
    echo ==========================================================
    set /p OPCAO="Digite a opção (0-9): "
)

if "%OPCAO%"=="1" (call "docker\start.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="2" (call "podman\start-pod.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="3" (call "podman\start-compose.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="4" (call "kubernetes\deploy.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="5" (call "config\start.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="6" (call "docker\stop.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="7" (call "podman\stop-pod.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="8" (call "kubernetes\destroy.bat" %APP_LANG% & goto MENU)
if "%OPCAO%"=="9" (goto LANG_SELECT)
if "%OPCAO%"=="0" (exit /b 0)

goto MENU
