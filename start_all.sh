#!/bin/bash

# Script pour lancer la base de données et le backend
# Auteur: Antigravity

# Définition des chemins
BASE_DIR="/home/zfred/Bureau/Ecole/Soutenance/Fred-Soutenance/fred_soutenance_app"
BACKEND_DIR="$BASE_DIR/backend"

echo "------------------------------------------"
echo "🚀 Lancement du projet Urbania"
echo "------------------------------------------"

# 1. Lancement de MongoDB via Docker
echo "🐳 Étape 1: Lancement de la base de données (MongoDB)..."
cd "$BACKEND_DIR" || { echo "❌ Dossier backend introuvable"; exit 1; }
docker compose up -d

if [ $? -eq 0 ]; then
    echo "✅ MongoDB est opérationnel (en arrière-plan)."
else
    echo "❌ Échec du lancement de MongoDB."
    exit 1
fi

# 2. Lancement du Backend FastAPI
echo "🐍 Étape 2: Lancement du backend (FastAPI)..."

# Vérification de l'environnement virtuel
if [ ! -d "venv" ]; then
    echo "❌ L'environnement virtuel 'venv' est introuvable dans $BACKEND_DIR."
    echo "💡 Essayez de le créer avec : python -m venv venv && pip install -r requirements.txt"
    exit 1
fi

# Activation et lancement en arrière-plan
source venv/bin/activate
nohup python main.py > "$BACKEND_DIR/backend.log" 2>&1 &
echo $! > "$BACKEND_DIR/.backend.pid"

echo "✅ Backend lancé avec succès (PID: $(cat "$BACKEND_DIR/.backend.pid"))."
echo "📝 Les logs sont disponibles dans : $BACKEND_DIR/backend.log"

# 3. Lancement du serveur LiveKit
echo "🎥 Étape 3: Lancement du serveur LiveKit..."
cd "$BASE_DIR" || { echo "❌ Impossible de retourner au répertoire de base"; exit 1; }

# Rendre le script exécutable si nécessaire
chmod +x start_livekit.sh

# Lancer LiveKit
./start_livekit.sh

if [ $? -eq 0 ]; then
    echo "✅ LiveKit est opérationnel."
else
    echo "❌ Échec du lancement de LiveKit."
    exit 1
fi

echo "------------------------------------------"
echo "🌐 API accessible sur : http://localhost:8000"
echo "🎥 LiveKit WebSocket : ws://localhost:7880"
echo "------------------------------------------"

