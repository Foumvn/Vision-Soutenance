#!/bin/bash

# Script global pour lancer TOUS les services (BD, Backend, LiveKit, Ngrok)


# Couleurs pour le terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Définition des chemins absolus pour éviter les erreurs
BASE_DIR="/home/zfred/Bureau/Ecole/Soutenance/Fred-Soutenance/fred_soutenance_app"
BACKEND_DIR="$BASE_DIR/backend"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🚀  LANCEMENT GLOBAL DU PROJET VISION-Meet  🚀${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# 1. Lancement de MongoDB via Docker
echo -e "${CYAN}🐳 Étape 1: Lancement de la base de données (MongoDB)...${NC}"
cd "$BACKEND_DIR" || { echo -e "${RED}❌ Dossier backend introuvable${NC}"; exit 1; }
docker compose up -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ MongoDB est opérationnel.${NC}"
else
    echo -e "${RED}❌ Échec du lancement de MongoDB.${NC}"
    exit 1
fi
echo ""

# 2. Lancement du Backend FastAPI
echo -e "${CYAN}🐍 Étape 2: Lancement du backend (FastAPI)...${NC}"

# Vérification de l'environnement virtuel
if [ ! -d "venv" ]; then
    echo -e "${RED}❌ L'environnement virtuel 'venv' est introuvable dans $BACKEND_DIR.${NC}"
    echo -e "${YELLOW}💡 Création automatique de l'environnement virtuel...${NC}"
    python3 -m venv venv
    source venv/bin/activate
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        echo -e "${RED}❌ requirements.txt introuvable.${NC}"
        exit 1
    fi
fi

# Activation et lancement en arrière-plan
source venv/bin/activate
# Tuer l'ancien backend s'il existe
if [ -f "$BACKEND_DIR/.backend.pid" ]; then
    OLD_PID=$(cat "$BACKEND_DIR/.backend.pid")
    if ps -p $OLD_PID > /dev/null; then
        kill $OLD_PID
    fi
fi

nohup python main.py > "$BACKEND_DIR/backend.log" 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > "$BACKEND_DIR/.backend.pid"

# Attendre un peu pour vérifier si le backend ne crashe pas tout de suite
sleep 2
if ps -p $BACKEND_PID > /dev/null; then
    echo -e "${GREEN}✅ Backend lancé avec succès (PID: $BACKEND_PID).${NC}"
else
    echo -e "${RED}❌ Le backend a échoué au démarrage. Voir logs: $BACKEND_DIR/backend.log${NC}"
    exit 1
fi
echo ""

# 3. Lancement du serveur LiveKit
echo -e "${CYAN}🎥 Étape 3: Lancement du serveur LiveKit...${NC}"
cd "$BASE_DIR" || { echo -e "${RED}❌ Impossible de retourner au répertoire de base${NC}"; exit 1; }
chmod +x start_livekit.sh
./start_livekit.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Échec du lancement de LiveKit.${NC}"
    exit 1
fi
# start_livekit.sh imprime déjà ses propres logs de succès
echo ""

# 4. Lancement de Ngrok
echo -e "${CYAN}🌍 Étape 4: Lancement de Ngrok...${NC}"
chmod +x start_ngrok.sh

# Nous lançons start_ngrok.sh qui gère sa propre attente et récupération d'URL
./start_ngrok.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Échec du lancement de Ngrok.${NC}"
    # On continue quand même pour afficher le résumé des autres services
else
    echo -e "${GREEN}✅ Ngrok lancé.${NC}"
fi

# Récupération finale de l'URL Ngrok pour le tableau récapitulatif
sleep 1
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

if [ "$NGROK_URL" == "null" ] || [ -z "$NGROK_URL" ]; then
    NGROK_URL="${RED}Non disponible${NC}"
fi

# Tableau Récapitulatif
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📊  RÉSUMÉ DES SERVICES ACTIFS  📊${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}Service          Status       URL / Info${NC}"
echo -e "────────────────────────────────────────────────────────────"
echo -e "🐳 MongoDB       ${GREEN}En ligne${NC}     docker-compose (port 27017)"
echo -e "🐍 Backend       ${GREEN}En ligne${NC}     http://localhost:8000"
echo -e "🎥 LiveKit       ${GREEN}En ligne${NC}     ws://localhost:7880"
echo -e "🌍 Ngrok         ${GREEN}En ligne${NC}     ${YELLOW}$NGROK_URL${NC}"
echo -e "────────────────────────────────────────────────────────────"
echo ""
echo -e "${YELLOW}📝 N'oubliez pas de mettre à jour votre fichier .env frontend avec l'URL Ngrok !${NC}"
echo -e "   NEXT_PUBLIC_API_URL=$NGROK_URL"
echo ""
echo -e "${BLUE}Pour tout arrêter : ./stop_all.sh${NC}"
echo ""

