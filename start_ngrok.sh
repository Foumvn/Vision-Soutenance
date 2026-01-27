#!/bin/bash

# Script pour lancer ngrok et exposer le backend local
# Ce script démarre ngrok sur le port 8000 (backend FastAPI)

echo "🚀 Démarrage de ngrok pour exposer le backend..."
echo ""

# Lancer ngrok en arrière-plan et capturer l'URL
ngrok http 8000 --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!
echo $NGROK_PID > /tmp/ngrok.pid

echo "⏳ Attente du démarrage de ngrok..."
sleep 3

# Récupérer l'URL publique de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -oP '"public_url":"https://[^"]+' | grep -oP 'https://[^"]+' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Erreur: Impossible de récupérer l'URL ngrok"
    echo "   Vérifiez que ngrok est bien lancé"
    echo "   Vous pouvez aussi ouvrir http://localhost:4040 dans votre navigateur"
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
