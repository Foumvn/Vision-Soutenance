#!/bin/bash

# Script pour visualiser les logs en temps réel
# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_DIR="/home/zfred/Bureau/Ecole/Soutenance/Fred-Soutenance/fred_soutenance_app"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📋  LECTEUR DE LOGS VISION-Meet  📋${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo "Choisissez quel log visualiser :"
echo "1) Backend (FastAPI)"
echo "2) LiveKit Server"
echo "3) MongoDB (Docker)"
echo "4) TOUT EN MÊME TEMPS (Multi-tail)"
echo "q) Quitter"

read -p "Option : " choice

case $choice in
    1)
        echo -e "${CYAN}Affichage des logs Backend... (CTRL+C pour arrêter)${NC}"
        tail -f "$BASE_DIR/backend/backend.log"
        ;;
    2)
        echo -e "${CYAN}Affichage des logs LiveKit... (CTRL+C pour arrêter)${NC}"
        tail -f "$BASE_DIR/livekit.log"
        ;;
    3)
        echo -e "${CYAN}Affichage des logs MongoDB... (CTRL+C pour arrêter)${NC}"
        docker logs -f urbania_mongodb
        ;;
    4)
        echo -e "${YELLOW}Affichage combiné (Backend et LiveKit)...${NC}"
        # Utilise tail sur plusieurs fichiers proprement
        tail -f "$BASE_DIR/backend/backend.log" "$BASE_DIR/livekit.log"
        ;;
    q)
        exit 0
        ;;
    *)
        echo "Option invalide"
        ;;
esac
