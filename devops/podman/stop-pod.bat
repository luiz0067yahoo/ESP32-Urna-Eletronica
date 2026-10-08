@echo off
set POD_NAME=urna-pod
echo Parando e removendo Podman Pod '%POD_NAME%'...
podman pod rm -f %POD_NAME% 2>nul
echo Pod finalizado com sucesso.
pause
