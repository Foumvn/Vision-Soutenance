#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$PROJECT_DIR/.livekit.pid"

echo -e "${BLUE}🛑 Arrêt du serveur LiveKit...${NC}"

if [ ! -f "$PID_FILE" ]; then
    echo -e "${RED}❌ Aucun serveur LiveKit en cours d'exécution${NC}"
    exit 1
fi

PID=$(cat "$PID_FILE")

if ps -p "$PID" > /dev/null 2>&1; then
    kill "$PID"
    rm "$PID_FILE"
    echo -e "${GREEN}✅ Serveur LiveKit arrêté (PID: $PID)${NC}"
else
    echo -e "${RED}❌ Le processus LiveKit (PID: $PID) n'est pas en cours d'exécution${NC}"
    rm "$PID_FILE"
    exit 1
fi
