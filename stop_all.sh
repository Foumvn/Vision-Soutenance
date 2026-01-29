#!/bin/bash

# Script global pour arrêter TOUS les services
# Auteur: Antigravity

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Définition des chemins
BASE_DIR="/home/zfred/Bureau/Ecole/Soutenance/Fred-Soutenance/fred_soutenance_app"
BACKEND_DIR="$BASE_DIR/backend"
PID_FILE="$BACKEND_DIR/.backend.pid"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🛑  ARRÊT GLOBAL DU PROJET VISION-SOUTENANCE  🛑${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# 1. Arrêt du Backend FastAPI
echo -e "${BLUE}🐍 Étape 1: Arrêt du backend...${NC}"
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        kill $PID
        echo -e "${GREEN}✅ Backend (PID $PID) arrêté.${NC}"
    else
        echo -e "${RED}⚠️  Le processus $PID n'est plus en cours (nettoyage du fichier PID).${NC}"
    fi
    rm "$PID_FILE"
else
    echo -e "${RED}⚠️  Aucun fichier PID trouvé. Le backend n'est peut-être pas lancé par le script.${NC}"
fi

# 2. Arrêt de MongoDB via Docker
echo ""
echo -e "${BLUE}🐳 Étape 2: Arrêt de la base de données (MongoDB)...${NC}"
cd "$BACKEND_DIR" || { echo "❌ Dossier backend introuvable"; exit 1; }
docker compose stop

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ MongoDB arrêté.${NC}"
else
    echo -e "${RED}❌ Échec de l'arrêt de MongoDB.${NC}"
fi

# 3. Arrêt du serveur LiveKit
echo ""
echo -e "${BLUE}🎥 Étape 3: Arrêt du serveur LiveKit...${NC}"
cd "$BASE_DIR" || { echo "❌ Impossible de retourner au répertoire de base"; exit 1; }
chmod +x stop_livekit.sh
./stop_livekit.sh

# 4. Arrêt de Ngrok
echo ""
echo -e "${BLUE}🌍 Étape 4: Arrêt de Ngrok...${NC}"
chmod +x stop_ngrok.sh
./stop_ngrok.sh

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Tous les services ont été arrêtés avec succès.${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
