@echo off
cd /d %~dp0

echo "Liste des branches disponibles :"
git branch

set /p branchChoice="Entrez le nom de la branche sur laquelle vous souhaitez vous positionner : "

echo "Passage à la branche %branchChoice%..."
git checkout %branchChoice%

echo "Exécution de git fetch..."
git fetch

echo "Exécution de git pull..."
git pull

echo "Opérations terminées."
pause
