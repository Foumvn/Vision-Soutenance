# ⚡ Quick Start - LiveKit Urbania

## 🚀 Démarrage en 3 étapes

### Étape 1: Installer les dépendances

```bash
# Backend
cd backend
source venv/bin/activate
pip install -r requirements.txt

# Frontend
cd ../web
npm install

# Retour à la racine
cd ..
```

### Étape 2: Démarrer l'application

```bash
./start_all.sh
```

Cela démarre:
- ✅ MongoDB (port 27018)
- ✅ Backend FastAPI (port 8000)
- ✅ Serveur LiveKit (port 7880)

### Étape 3: Lancer le frontend

```bash
cd web
npm run dev
```

Frontend accessible sur: **http://localhost:3000**

## 🎯 Test rapide

1. Ouvrir http://localhost:3000
2. Se connecter avec un compte
3. Dashboard → "New Meeting"
4. Configurer l'appel et démarrer
5. Ouvrir un 2ème navigateur
6. Rejoindre la room
7. ✅ Visioconférence fonctionne!

## 🛑 Arrêter l'application

```bash
./stop_all.sh
```

## 📚 Documentation complète

- **Guide d'utilisation**: `GUIDE_LIVEKIT_USAGE.md`
- **README détaillé**: `README_LIVEKIT.md`
- **Architecture**: `ARCHITECTURE_LIVEKIT.md`
- **Résumé implémentation**: `IMPLEMENTATION_SUMMARY.md`

## ⚙️ Configuration

### Backend (.env)
```env
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
LIVEKIT_URL=ws://localhost:7880
```

### LiveKit (livekit.yaml)
```yaml
port: 7880
keys:
  devkey: secret
```

## 🔗 URLs importantes

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- LiveKit WebSocket: ws://localhost:7880

## 🎨 Pages principales

- `/dashboard` - Tableau de bord
- `/meeting/pre-join` - Créer une visioconférence
- `/meeting/room?room=xxx` - Salle de visioconférence
- `/meeting/invite?room=xxx` - Rejoindre via invitation

## 🔐 Authentication

Tous les endpoints nécessitent un JWT token:

```typescript
// Login
POST /api/auth/login
{ email, password }

// Utiliser le token
headers: {
  'Authorization': `Bearer ${token}`
}
```

## 🎥 API Endpoints clés

```bash
# Créer une room
POST /api/livekit/rooms
{
  "room_name": "my-room",
  "participants": ["user1", "user2"],
  "call_type": "video"
}

# Obtenir un token LiveKit
POST /api/livekit/token
{
  "room_name": "my-room",
  "user_id": "user123",
  "username": "John Doe"
}

# Rejoindre une room
POST /api/livekit/rooms/{room_name}/join

# Quitter une room
POST /api/livekit/rooms/{room_name}/leave
```

## 🐛 Dépannage rapide

### LiveKit ne démarre pas
```bash
# Vérifier les logs
cat livekit.log

# Vérifier le port
lsof -i :7880

# Redémarrer
./stop_livekit.sh && ./start_livekit.sh
```

### Backend ne démarre pas
```bash
# Vérifier les dépendances
cd backend
source venv/bin/activate
pip install -r requirements.txt

# Vérifier MongoDB
docker ps
```

### Frontend erreur
```bash
# Réinstaller les dépendances
cd web
rm -rf node_modules package-lock.json
npm install
```

## 💡 Conseils

- **Développement**: Utilisez 2 navigateurs différents pour tester les appels
- **Permissions**: Autorisez caméra/micro dans le navigateur
- **Réseau**: LiveKit fonctionne en local, pour production configurez STUN/TURN
- **Logs**: Consultez `livekit.log` et `backend/backend.log` en cas de problème

## 🎓 Pour aller plus loin

1. Lire `GUIDE_LIVEKIT_USAGE.md` pour la doc complète
2. Consulter `ARCHITECTURE_LIVEKIT.md` pour comprendre l'architecture
3. Voir `IMPLEMENTATION_SUMMARY.md` pour tous les détails

## ⭐ Fonctionnalités disponibles

- ✅ Appels vidéo 1-to-1
- ✅ Appels de groupe
- ✅ Appels audio seulement
- ✅ Contrôles (mute mic, camera on/off)
- ✅ Interface moderne
- ✅ Sélection de participants
- ✅ Système d'invitation

## 🚀 Prochaines étapes

- [ ] Implémenter persistance MongoDB
- [ ] Ajouter partage d'écran
- [ ] Ajouter chat textuel
- [ ] Notifications push
- [ ] Tests automatisés

---

**Bon développement! 🎉**
