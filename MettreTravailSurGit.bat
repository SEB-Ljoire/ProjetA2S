@echo off
cd /d %~dp0

set /p commitMessage="Entrez le message de commit : "

echo "Ajout des fichiers modifiés au suivi de version..."
git add .

echo "Exécution de git commit..."
git commit -m "%commitMessage%"

echo "Exécution de git push..."
git push

echo "Opérations terminées."
pause
