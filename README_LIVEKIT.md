# 🎥 Système de Visioconférence LiveKit - Urbania

## ✨ Fonctionnalités

- ✅ Appels vidéo/audio 1-to-1 et de groupe
- ✅ Interface moderne et responsive
- ✅ Gestion des participants en temps réel
- ✅ Contrôles audio/vidéo (mute, camera on/off)
- ✅ Sélection des participants depuis les contacts
- ✅ Page de pré-jointure avec configuration
- ✅ Système d'invitation avec lien direct
- ✅ Architecture SFU (Selective Forwarding Unit) via LiveKit
- ✅ Authentification sécurisée avec JWT
- ✅ API REST complète pour la gestion des rooms

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      URBANIA LIVEKIT                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────┐  │
│  │   Frontend   │      │   Backend    │      │ LiveKit  │  │
│  │   Next.js    │◀────▶│   FastAPI    │◀────▶│  Server  │  │
│  │              │      │              │      │   SFU    │  │
│  └──────────────┘      └──────────────┘      └──────────┘  │
│         │                     │                     │        │
│    Components           Token Gen             Transport     │
│    - Pre-join          - Room Mgmt           - WebRTC       │
│    - Room UI           - JWT Auth            - Audio/Video  │
│    - Invite            - API REST                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Structure du projet

```
urbania/
├── backend/
│   ├── app/
│   │   ├── api/endpoints/
│   │   │   └── livekit.py          # API endpoints LiveKit
│   │   ├── core/
│   │   │   ├── config.py           # Configuration (MAJ avec LiveKit)
│   │   │   └── livekit_service.py  # Service de génération tokens
│   │   └── models/
│   │       └── livekit.py          # Modèles Pydantic
│   ├── requirements.txt            # Dépendances (+ livekit, livekit-api)
│   └── .env                        # Variables d'environnement
│
├── web/
│   ├── app/
│   │   ├── lib/
│   │   │   └── api.ts              # API client (+ fonctions LiveKit)
│   │   └── meeting/
│   │       ├── pre-join/
│   │       │   └── page.tsx        # Configuration avant l'appel
│   │       ├── room/
│   │       │   └── page.tsx        # Salle de visioconférence
│   │       └── invite/
│   │           └── page.tsx        # Rejoindre via invitation
│   └── package.json                # Dépendances (+ @livekit/*)
│
├── livekit_1.9.0_linux_amd64/
│   └── livekit-server              # Binaire LiveKit
│
├── livekit.yaml                    # Configuration LiveKit
├── start_livekit.sh                # Script démarrage LiveKit
├── stop_livekit.sh                 # Script arrêt LiveKit
├── start_all.sh                    # Démarrer tous les services (MAJ)
├── stop_all.sh                     # Arrêter tous les services (MAJ)
├── GUIDE_LIVEKIT_USAGE.md          # Guide d'utilisation complet
└── README_LIVEKIT.md               # Ce fichier
```

## 🚀 Démarrage rapide

### 1. Installation des dépendances

#### Backend
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

#### Frontend
```bash
cd web
npm install
```

### 2. Configuration

#### Backend (.env)
```env
# LiveKit Configuration
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
LIVEKIT_URL=ws://localhost:7880
```

#### LiveKit (livekit.yaml)
Déjà configuré avec les bons paramètres pour le développement local.

### 3. Démarrer l'application

```bash
# Démarrer tous les services (MongoDB, Backend, LiveKit)
./start_all.sh
```

Ou démarrer individuellement:
```bash
# LiveKit seulement
./start_livekit.sh

# Backend seulement
cd backend && python main.py

# Frontend seulement
cd web && npm run dev
```

### 4. Accéder à l'application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **LiveKit WebSocket**: ws://localhost:7880
- **API Docs**: http://localhost:8000/docs

## 💻 Utilisation

### Créer une visioconférence

1. Connectez-vous à l'application
2. Dashboard → Cliquez sur **"New Meeting"**
3. Configurez votre appel:
   - Nom de la room
   - Type (Audio/Vidéo)
   - Participants
4. Cliquez sur **"Démarrer l'appel"**

### Rejoindre une visioconférence

1. Recevez un lien d'invitation
2. Cliquez sur le lien
3. Vérifiez les infos
4. Cliquez sur **"Rejoindre"**

### Pendant l'appel

- 🎤 Toggle microphone
- 📹 Toggle caméra
- 🚪 Quitter l'appel
- 👥 Voir les participants

## 📡 API Endpoints

### Authentification
Tous les endpoints nécessitent un JWT token:
```
Authorization: Bearer <votre_token_jwt>
```

### Endpoints disponibles

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/api/livekit/token` | Obtenir un token LiveKit |
| POST | `/api/livekit/rooms` | Créer une room |
| GET | `/api/livekit/rooms` | Lister mes rooms |
| GET | `/api/livekit/rooms/{room_name}` | Infos d'une room |
| POST | `/api/livekit/rooms/{room_name}/join` | Rejoindre une room |
| POST | `/api/livekit/rooms/{room_name}/leave` | Quitter une room |
| DELETE | `/api/livekit/rooms/{room_name}` | Supprimer une room |

### Exemple: Créer une room

```bash
curl -X POST http://localhost:8000/api/livekit/rooms \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "room_name": "team-meeting",
    "participants": ["user1", "user2"],
    "call_type": "video"
  }'
```

## 🎨 Composants Frontend

### PreJoinPage (`/meeting/pre-join`)
- Configuration de l'appel
- Sélection des participants
- Choix du type d'appel

### RoomPage (`/meeting/room?room=...`)
- Interface de visioconférence
- Affichage des vidéos
- Contrôles audio/vidéo

### InvitePage (`/meeting/invite?room=...`)
- Affichage des infos de la room
- Bouton pour rejoindre

## 🔐 Sécurité

### Authentification en deux couches

1. **JWT Backend** (FastAPI)
   - Login → Token JWT
   - Token requis pour tous les endpoints
   - Validité: 30 minutes (configurable)

2. **Token LiveKit**
   - Généré par le backend pour chaque utilisateur/room
   - Contient l'identité et les permissions
   - Signé avec la clé secrète LiveKit
   - Usage unique par room

### Flux de sécurité

```
User → Login → JWT Token
          ↓
     API Request (avec JWT)
          ↓
    Backend valide JWT
          ↓
   Génère Token LiveKit
          ↓
    Frontend connecte LiveKit
```

## 🧪 Tests

### Test manuel

1. **Test appel 1-to-1**
   - Ouvrir 2 navigateurs
   - Se connecter avec 2 utilisateurs
   - User 1 crée room
   - User 2 rejoint
   - Vérifier vidéo/audio

2. **Test appel de groupe**
   - 3+ utilisateurs
   - Tous rejoignent la même room
   - Vérifier toutes les vidéos

### Dépannage

```bash
# Voir les logs LiveKit
tail -f livekit.log

# Voir les logs backend
tail -f backend/backend.log

# Vérifier que LiveKit tourne
ps aux | grep livekit-server

# Tester la connexion WebSocket
wscat -c ws://localhost:7880
```

## 📦 Dépendances

### Backend
- `livekit` - SDK Python LiveKit
- `livekit-api` - API client LiveKit
- `websockets` - Support WebSocket

### Frontend
- `@livekit/components-react` - Composants React LiveKit
- `@livekit/components-styles` - Styles par défaut
- `livekit-client` - SDK client LiveKit

## 🔧 Configuration avancée

### Augmenter le nombre de participants

```yaml
# livekit.yaml
room:
  max_participants: 200  # Augmenter selon besoins
```

### Changer le port LiveKit

```yaml
# livekit.yaml
port: 8880  # Nouveau port
```

```env
# backend/.env
LIVEKIT_URL=ws://localhost:8880
```

### Mode production

```yaml
# livekit.yaml
rtc:
  use_external_ip: true
  node_ip: "YOUR_PUBLIC_IP"
```

```env
# backend/.env
LIVEKIT_URL=wss://your-domain.com
LIVEKIT_API_KEY=production-key
LIVEKIT_API_SECRET=production-secret
```

## 🐛 Problèmes courants

### LiveKit ne démarre pas
```bash
# Vérifier si le port est libre
lsof -i :7880

# Tuer le processus si nécessaire
kill -9 $(lsof -t -i:7880)

# Redémarrer
./start_livekit.sh
```

### Token invalide
- Vérifier que les clés API correspondent dans `.env` et `livekit.yaml`
- Vérifier que le JWT backend n'a pas expiré

### Pas de vidéo
- Autoriser caméra/micro dans le navigateur
- Vérifier la console pour erreurs
- S'assurer que LiveKit est démarré

## 📚 Ressources

- [Guide d'utilisation complet](./GUIDE_LIVEKIT_USAGE.md)
- [Documentation LiveKit](https://docs.livekit.io/)
- [LiveKit React SDK](https://docs.livekit.io/client-sdk-react/)
- [LiveKit Python SDK](https://docs.livekit.io/server-sdk-python/)

## 🎯 Prochaines étapes

- [ ] Persistance rooms dans MongoDB
- [ ] Notifications pour invitations
- [ ] Partage d'écran
- [ ] Chat textuel
- [ ] Enregistrement des appels
- [ ] Salle d'attente
- [ ] Statistiques de qualité

## 📝 Changelog

### Version 1.0.0 (2026-01-24)
- ✨ Implémentation initiale
- ✅ Backend API complète
- ✅ Frontend avec 3 pages (pre-join, room, invite)
- ✅ Scripts de démarrage/arrêt
- ✅ Documentation complète

## 👨‍💻 Développé par

Implémentation LiveKit pour Urbania  
Janvier 2026
