#!/bin/bash

# Script de test du système de notifications
# Ce script teste le flux complet de notifications

echo "======================================"
echo "Test du système de notifications"
echo "======================================"
echo ""

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
API_URL="http://localhost:8000"
TOKEN=""
USER_EMAIL="test@example.com"

echo -e "${BLUE}1. Vérification du backend...${NC}"
if curl -s "${API_URL}/docs" > /dev/null; then
    echo -e "${GREEN}✓ Backend accessible${NC}"
else
    echo -e "${RED}✗ Backend non accessible${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}2. État actuel des notifications${NC}"
echo "Connectez-vous à l'application web pour tester:"
echo ""
echo "  • Créez une nouvelle réunion"
echo "  • Invitez un participant"
echo "  • Vérifiez que le participant reçoit une notification"
echo "  • Cliquez sur 'Clear All' ou 'Dismiss'"
echo "  • Vérifiez que les notifications disparaissent"
echo "  • Créez une nouvelle réunion"
echo "  • Vérifiez que la nouvelle notification apparaît"
echo ""

echo -e "${BLUE}3. Vérification en base de données${NC}"
echo "Les notifications marquées comme lues restent en BD:"
echo ""
echo "Commande MongoDB à exécuter:"
echo -e "${GREEN}db.users.find({ email: 'votre@email.com' }, { notifications: 1 })${NC}"
echo ""
echo "Vous devriez voir:"
echo "  - Notifications avec read: false (nouvelles)"
echo "  - Notifications avec read: true (archivées)"
echo ""

echo -e "${BLUE}4. Points de test${NC}"
echo "✓ Badge de la cloche affiche le bon nombre"
echo "✓ Section 'Upcoming Meetings' affiche uniquement les non lues"
echo "✓ Bouton 'Clear All' marque tout comme lu"
echo "✓ Bouton 'Dismiss' dans la bannière fonctionne"
echo "✓ Les notifications disparaissent après nettoyage"
echo "✓ Les nouvelles notifications apparaissent normalement"
echo ""

echo -e "${BLUE}5. Logs backend à surveiller${NC}"
echo "tail -f backend/backend.log | grep -E 'notifications|clear'"
echo ""

echo "======================================"
echo "Test manuel requis - Suivez les étapes ci-dessus"
echo "======================================"
