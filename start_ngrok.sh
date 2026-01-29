#!/bin/bash

# Script pour lancer ngrok et exposer le backend local
# Ce script démarre ngrok sur le port 8000 (backend FastAPI)

echo "🚀 Démarrage de ngrok pour exposer le backend..."
echo ""

# Arrêter toute instance précédente de ngrok pour éviter les conflits
# Utilisation de -x pour matcher exactement le processus "ngrok" et éviter de tuer le script lui-même
if pgrep -x "ngrok" > /dev/null; then
    echo "⚠️  Arrêt des instances précédentes de ngrok..."
    pkill -x "ngrok"
    # Attendre que le processus soit bien terminé
    sleep 2
fi

# Lancer ngrok en arrière-plan et capturer l'URL
# Utilisation de nohup pour éviter que le processus ne soit tué à la fermeture du terminal
nohup ngrok http 8000 --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!
echo $NGROK_PID > /tmp/ngrok.pid

echo "⏳ Attente de l'initialisation du tunnel..."

# Boucle de tentative pour récupérer l'URL (max 30 secondes)
MAX_RETRIES=30
COUNT=0
NGROK_URL=""

while [ $COUNT -lt $MAX_RETRIES ]; do
    sleep 1
    # Utilisation de jq pour une extraction JSON fiable si disponible
    if command -v jq >/dev/null 2>&1; then
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    else
        # Fallback grep si jq absent
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -oP '"public_url":"https://[^"]+' | grep -oP 'https://[^"]+' | head -1)
    fi

    # Vérifier si l'URL est valide (non vide et non "null")
    if [ -n "$NGROK_URL" ] && [ "$NGROK_URL" != "null" ]; then
        break
    fi
    
    echo -ne "." # Indicateur de progression
    COUNT=$((COUNT+1))
done
echo ""

if [ -z "$NGROK_URL" ] || [ "$NGROK_URL" == "null" ]; then
    echo "❌ Erreur: Impossible de récupérer l'URL ngrok après ${MAX_RETRIES} secondes"
    echo "   Vérifiez que ngrok est bien installé et authentifié."
    echo "   Dernières lignes de log (/tmp/ngrok.log):"
    tail -n 10 /tmp/ngrok.log
    
    # Nettoyage si échec
    kill $NGROK_PID 2>/dev/null
    exit 1
fi

echo ""
echo "✅ ngrok est lancé avec succès!"
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🌐 URL publique de votre backend: $NGROK_URL"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📝 Actions à faire sur Vercel:"
echo "   1. Allez dans les paramètres de votre projet Vercel"
echo "   2. Dans 'Environment Variables', ajoutez:"
echo ""
echo "      NEXT_PUBLIC_API_URL = $NGROK_URL"
echo ""
echo "   3. Redéployez votre projet pour appliquer les changements"
echo ""
echo "⚠️  Note: L'URL ngrok change à chaque redémarrage (version gratuite)"
echo "   Vous devrez mettre à jour Vercel à chaque fois que vous relancez ngrok"
echo ""
echo "📊 Interface ngrok: http://localhost:4040"
echo ""
echo "Pour arrêter ngrok, exécutez: ./stop_ngrok.sh"
