@echo off
cd /d "%~dp0"
echo Parando containers Docker...
docker compose down
echo Containers finalizados com sucesso.
pause
