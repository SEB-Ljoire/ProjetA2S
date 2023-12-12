@echo off
cd /d %~dp0

echo "Exécution de git fetch..."
git fetch

echo "Exécution de git pull..."
git pull

echo "Opérations terminées."
pause
