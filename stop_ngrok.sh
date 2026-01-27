#!/bin/bash

# Script pour arrêter ngrok

echo "🛑 Arrêt de ngrok..."

if [ -f /tmp/ngrok.pid ]; then
    NGROK_PID=$(cat /tmp/ngrok.pid)
    if kill $NGROK_PID 2>/dev/null; then
        echo "✅ ngrok arrêté (PID: $NGROK_PID)"
        rm /tmp/ngrok.pid
    else
        echo "⚠️  Le processus ngrok n'était plus actif"
        rm /tmp/ngrok.pid
    fi
else
    # Essayer de tuer tous les processus ngrok
    pkill -f "ngrok http" && echo "✅ Tous les processus ngrok ont été arrêtés" || echo "⚠️  Aucun processus ngrok trouvé"
fi
