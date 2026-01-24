# 🎥 Guide d'Utilisation - LiveKit pour Urbania

## 📋 Vue d'ensemble

Ce guide explique comment utiliser le système de visioconférence LiveKit intégré dans votre application Urbania.

## 🏗️ Architecture

L'implémentation LiveKit dans Urbania suit une architecture SFU (Selective Forwarding Unit) composée de trois parties principales:

### 1. **Backend (Python/FastAPI)**
- Génération de tokens JWT pour l'authentification LiveKit
- Gestion des rooms (création, jointure, départ)
- API REST sécurisée avec JWT

### 2. **Frontend (Next.js/React)**
- Interface utilisateur de visioconférence
- Composants LiveKit React pour affichage vidéo/audio
- Pages de pré-jointure et d'invitation

### 3. **Serveur LiveKit**
- Transport SFU des flux audio/vidéo
- Gestion des participants
- Connexion WebSocket (ws://localhost:7880)

## 🚀 Démarrage

### Démarrer tous les services

```bash
./start_all.sh
```

Ce script démarre dans l'ordre:
1. MongoDB (via Docker)
2. Backend FastAPI
3. Serveur LiveKit

### Démarrer uniquement LiveKit

```bash
./start_livekit.sh
```

### Arrêter tous les services

```bash
./stop_all.sh
```

### Arrêter uniquement LiveKit

```bash
./stop_livekit.sh
```

## 📡 Endpoints API

### Obtenir un token LiveKit
```http
POST /api/livekit/token
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "room_name": "my-room",
  "user_id": "user123",
  "username": "John Doe"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "url": "ws://localhost:7880",
  "room_name": "my-room"
}
```

### Créer une room
```http
POST /api/livekit/rooms
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "room_name": "team-meeting",
  "participants": ["user1", "user2", "user3"],
  "call_type": "video"  // "audio" ou "video"
}
```

### Rejoindre une room
```http
POST /api/livekit/rooms/{room_name}/join
Authorization: Bearer <jwt_token>
```

### Quitter une room
```http
POST /api/livekit/rooms/{room_name}/leave
Authorization: Bearer <jwt_token>
```

### Obtenir les informations d'une room
```http
GET /api/livekit/rooms/{room_name}
Authorization: Bearer <jwt_token>
```

### Lister mes rooms
```http
GET /api/livekit/rooms
Authorization: Bearer <jwt_token>
```

## 🖥️ Utilisation Frontend

### Flux d'utilisation

#### 1. Créer une nouvelle visioconférence

1. Depuis le dashboard, cliquez sur **"New Meeting"**
2. Vous serez redirigé vers `/meeting/pre-join`
3. Configurez votre appel:
   - Donnez un nom à la room
   - Choisissez le type d'appel (Audio ou Vidéo)
   - Sélectionnez les participants dans votre liste de contacts
4. Cliquez sur **"Démarrer l'appel"**
5. Une room est créée et vous êtes redirigé vers `/meeting/room?room={room_name}`

#### 2. Rejoindre une visioconférence existante

1. Recevez un lien d'invitation: `/meeting/invite?room={room_name}`
2. Cliquez sur le lien
3. Vérifiez les informations de la room
4. Cliquez sur **"Rejoindre maintenant"**
5. Vous entrez dans la room

#### 3. Pendant l'appel

Dans la salle de visioconférence, vous pouvez:
- Voir les vidéos de tous les participants
- Activer/désactiver votre microphone
- Activer/désactiver votre caméra
- Voir qui est connecté
- Quitter l'appel

## 🔧 Configuration

### Variables d'environnement Backend (.env)

```env
# LiveKit Configuration
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
LIVEKIT_URL=ws://localhost:7880
```

### Configuration LiveKit (livekit.yaml)

```yaml
port: 7880
keys:
  devkey: secret

rtc:
  port_range_start: 50000
  port_range_end: 60000

room:
  auto_create: true
  empty_timeout: 300
  max_participants: 100
```

## 🔐 Sécurité

### Tokens JWT Backend

- Tous les endpoints sont protégés par JWT
- Le token doit être envoyé dans le header `Authorization: Bearer <token>`
- Obtenu après login: `POST /api/auth/login`

### Tokens LiveKit

- Générés par le backend pour chaque utilisateur/room
- Contiennent l'identité du participant et ses permissions
- Durée de validité configurable
- Ne jamais générer de tokens côté client

## 📊 Flux de Communication

```
┌─────────────┐      ┌──────────────┐      ┌────────────────┐
│  Frontend   │─────▶│   Backend    │─────▶│ LiveKit Server │
│  (Next.js)  │◀─────│  (FastAPI)   │◀─────│     (SFU)      │
└─────────────┘      └──────────────┘      └────────────────┘
      │                     │                       │
      │  1. Demande token   │                       │
      │────────────────────▶│                       │
      │  2. Retour token    │                       │
      │◀────────────────────│                       │
      │  3. Connexion WebSocket avec token          │
      │────────────────────────────────────────────▶│
      │  4. Échange médias (audio/vidéo)            │
      │◀────────────────────────────────────────────│
```

## 🎯 Cas d'usage

### Appel 1-to-1

```typescript
// Créer une room pour deux personnes
const room = await createRoom(
  `call-${userId1}-${userId2}`,
  [userId1, userId2],
  "video",
  accessToken
);

// Rediriger vers la room
router.push(`/meeting/room?room=${room.room_name}`);
```

### Appel de groupe

```typescript
// Créer une room pour plusieurs personnes
const participants = [currentUser.id, ...selectedContactIds];
const room = await createRoom(
  `team-meeting-${Date.now()}`,
  participants,
  "video",
  accessToken
);
```

### Webinaire (un speaker, plusieurs auditeurs)

```typescript
// Créer une room avec permissions personnalisées
// Le token du speaker aura can_publish=true
// Les tokens des auditeurs auront can_publish=false, can_subscribe=true
```

## 🧪 Tests

### Test 1: Appel vidéo 1-to-1
1. Ouvrez deux navigateurs/onglets
2. Connectez-vous avec deux utilisateurs différents
3. L'utilisateur 1 crée une room et invite l'utilisateur 2
4. L'utilisateur 2 rejoint la room
5. Vérifiez que les deux vidéos s'affichent

### Test 2: Appel audio seulement
1. Créez une room avec `call_type: "audio"`
2. Vérifiez que seul l'audio est transmis
3. Les caméras restent désactivées

### Test 3: Appel de groupe
1. Créez une room avec 3+ participants
2. Tous rejoignent la room
3. Vérifiez que toutes les vidéos s'affichent dans la grille

## 🐛 Dépannage

### Le serveur LiveKit ne démarre pas

```bash
# Vérifier les logs
cat livekit.log

# Vérifier si le port 7880 est déjà utilisé
lsof -i :7880

# Arrêter le processus existant
./stop_livekit.sh
```

### Token invalide

- Vérifiez que `LIVEKIT_API_KEY` et `LIVEKIT_API_SECRET` sont identiques dans:
  - Backend `.env`
  - `livekit.yaml`
- Vérifiez que le token JWT backend n'a pas expiré

### Pas de vidéo/audio

- Vérifiez les permissions navigateur pour caméra/microphone
- Ouvrez la console développeur pour voir les erreurs
- Vérifiez que le serveur LiveKit est démarré
- Testez la connexion WebSocket: `ws://localhost:7880`

### Room non trouvée

- Les rooms sont stockées en mémoire (redémarrage = perte des rooms)
- Pour la production, implémentez le stockage MongoDB
- Vérifiez que la room a bien été créée avant de rejoindre

## 🚀 Améliorations futures

### À court terme
- [ ] Persistance des rooms dans MongoDB
- [ ] Notifications push pour invitations
- [ ] Partage d'écran
- [ ] Chat textuel dans la room
- [ ] Enregistrement des appels

### À moyen terme
- [ ] Salle d'attente (waiting room)
- [ ] Lever la main
- [ ] Arrière-plans virtuels
- [ ] Filtres vidéo
- [ ] Statistiques de qualité réseau

### À long terme
- [ ] Intégration calendrier
- [ ] Transcription automatique
- [ ] Traduction en temps réel
- [ ] Mode webinaire avec Q&A
- [ ] Streaming vers YouTube/Twitch

## 📚 Ressources

- [Documentation LiveKit](https://docs.livekit.io/)
- [LiveKit React Components](https://docs.livekit.io/client-sdk-react/)
- [LiveKit Python SDK](https://docs.livekit.io/server-sdk-python/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

## ⚙️ Configuration de production

### Backend
```env
LIVEKIT_URL=wss://your-domain.com
LIVEKIT_API_KEY=your-production-key
LIVEKIT_API_SECRET=your-production-secret
```

### LiveKit Server
- Déployer sur un serveur dédié
- Configurer les certificats SSL (WSS://)
- Utiliser une IP publique ou nom de domaine
- Ouvrir les ports nécessaires (WebRTC: 50000-60000, WS: 7880)
- Configurer TURN/STUN pour les réseaux restrictifs

### Frontend
- Mettre à jour l'URL de l'API backend
- Activer HTTPS
- Gérer les permissions navigateur de manière robuste
