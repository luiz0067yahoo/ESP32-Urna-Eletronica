@echo off
REM ==============================================================================
REM INICIALIZADOR COMPLETO WINDOWS: FRONTEND + BACKEND + MYSQL (SEM DOCKER)
REM ==============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%..\"
set "PORT=8080"
set "DB_NAME=urna_eletronica"

REM Carrega configuracoes do devops\ENV se existir
if exist "%SCRIPT_DIR%ENV" (
    for /f "usebackq tokens=1,* delims==" %%A in ("%SCRIPT_DIR%ENV") do (
        set "k=%%A"
        if not "!k:~0,1!"=="#" (
            if /i "%%A"=="PORT" set "PORT=%%B"
        )
    )
)

echo ===================================================================
echo   URNA ELETRONICA POKEMON - INICIALIZACAO NATIVA (SEM DOCKER)
echo ===================================================================

REM 1. Tenta rodar a migracao do banco de dados local
echo 1. Verificando banco de dados MySQL local...
call "%SCRIPT_DIR%setup_db.bat" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo    -> Banco de dados pronto!
) else (
    echo    -> Certifique-se de que o MySQL/XAMPP esta iniciado.
)

REM 2. Inicia o servidor web na porta 8080
echo 2. Iniciando Servidor Web PHP na porta %PORT%...
echo.
echo    Urna Eletronica: http://localhost:%PORT%/frontend/index.html
echo    Apuracao ao Vivo: http://localhost:%PORT%/frontend/apuracao.html
echo    API REST Backend: http://localhost:%PORT%/backend/apuracao
echo.
echo Pressione Ctrl+C para encerrar o servidor.
echo ===================================================================

cd /d "%PROJECT_ROOT%"
start "" "http://localhost:%PORT%/frontend/index.html"
php -S 0.0.0.0:%PORT%
