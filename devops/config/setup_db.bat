@echo off
REM ==============================================================================
REM SCRIPT DE CONFIGURAÇÃO E MIGRAÇÃO DO BANCO MYSQL WINDOWS (SEM DOCKER)
REM ==============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%..\"

REM Carrega preferencialmente backend\.env, com fallback para backend\.env.example
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

if not "%~1"=="" set "DB_USER=%~1"
if not "%~2"=="" set "DB_PASS=%~2"
if not "%~3"=="" set "DB_NAME=%~3"

echo ===================================================================
echo [DEVOPS] Provisionando Banco de Dados MySQL: %DB_NAME% (Sem Docker)
echo Usando configuracao: %ENV_FILE%
echo ===================================================================

set "MYSQL_CMD=mysql -u %DB_USER% -h %DB_HOST%"
if not "%DB_PASS%"=="" set "MYSQL_CMD=%MYSQL_CMD% -p%DB_PASS%"

echo 1. Criando banco de dados %DB_NAME%...
%MYSQL_CMD% -e "CREATE DATABASE IF NOT EXISTS \`%DB_NAME%\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
if %ERRORLEVEL% NEQ 0 (
    echo [AVISO] Nao foi possivel conectar ao MySQL na porta padrao ou comando 'mysql' nao encontrado no PATH.
    echo Verifique se o XAMPP, WAMP ou MySQL Server esta rodando.
    exit /b 1
)

echo 2. Executando instalador inteligente: db\install.php...
php "%PROJECT_ROOT%db\install.php"

echo.
echo [SUCESSO] Banco de dados %DB_NAME% verificado e configurado com sucesso!
exit /b 0
