#!/bin/bash

# Script pour arrêter la base de données et le backend
# Auteur: Antigravity

# Définition des chemins
BASE_DIR="/home/zfred/Bureau/Ecole/Soutenance/Fred-Soutenance/fred_soutenance_app"
BACKEND_DIR="$BASE_DIR/backend"
PID_FILE="$BACKEND_DIR/.backend.pid"

echo "------------------------------------------"
echo "🛑 Arrêt du projet Urbania"
echo "------------------------------------------"

# 1. Arrêt du Backend FastAPI
echo "🐍 Étape 1: Arrêt du backend..."
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        kill $PID
        echo "✅ Backend (PID $PID) arrêté."
    else
        echo "⚠️  Le processus $PID n'est plus en cours (nettoyage du fichier PID)."
    fi
    rm "$PID_FILE"
else
    echo "⚠️  Aucun fichier PID trouvé. Le backend n'est peut-être pas lancé par le script."
fi

# 2. Arrêt de MongoDB via Docker
echo "🐳 Étape 2: Arrêt de la base de données (MongoDB)..."
cd "$BACKEND_DIR" || { echo "❌ Dossier backend introuvable"; exit 1; }
docker compose stop

if [ $? -eq 0 ]; then
    echo "✅ MongoDB arrêté."
else
    echo "❌ Échec de l'arrêt de MongoDB."
fi

# 3. Arrêt du serveur LiveKit
echo "🎥 Étape 3: Arrêt du serveur LiveKit..."
cd "$BASE_DIR" || { echo "❌ Impossible de retourner au répertoire de base"; exit 1; }

# Rendre le script exécutable si nécessaire
chmod +x stop_livekit.sh

# Arrêter LiveKit
./stop_livekit.sh

if [ $? -eq 0 ]; then
    echo "✅ LiveKit arrêté."
else
    echo "⚠️  LiveKit n'était peut-être pas en cours d'exécution."
fi

echo "------------------------------------------"
echo "✨ Tous les services sont arrêtés."
echo "------------------------------------------"
