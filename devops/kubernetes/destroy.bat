@echo off
cd /d "%~dp0"
echo Removendo recursos do Kubernetes...
kubectl delete -k .
kubectl delete namespace urna-eletronica
echo Recursos removidos com sucesso.
pause
