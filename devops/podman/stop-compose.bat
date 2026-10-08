@echo off
cd /d "%~dp0"
echo Parando containers do Podman Compose...
podman-compose -f podman-compose.yml down
echo Finalizado com sucesso.
pause
