# 🎥 Guide Complet - Intégration LiveKit pour Appels Vidéo/Audio

## ✅ État d'implémentation - COMPLET

### Backend Spring Boot ✅

#### 1. Dépendances
- ✅ `livekit-server-sdk:1.1.2` ajouté dans `pom.xml`

#### 2. Configuration
- ✅ Propriétés dans `application-dev.properties`:
  ```properties
  livekit.api.key=devkey
  livekit.api.secret=secret
  livekit.url=ws://192.168.100.6:7880
  livekit.token.ttl=3600
  aspnet.core.url=http://192.168.100.6:5000
  ```

#### 3. Services créés
- ✅ `LiveKitTokenService` : Génération tokens JWT LiveKit
- ✅ `CallService` : Gestion complète des appels (start, accept, reject, end)
- ✅ `CallNotificationService` : Notification ASP.NET Core SignalR
- ✅ `CallRepository` : Accès DB PostgreSQL

#### 4. Controllers créés
- ✅ `LiveKitTokenController` : 
  - `GET /api/livekit/token?room={room}&user={userId}` - Génère token LiveKit
- ✅ `CallController` :
  - `POST /api/calls/start` - Démarrer un appel
  - `POST /api/calls/{callId}/accept` - Accepter un appel
  - `POST /api/calls/{callId}/reject` - Refuser un appel
  - `POST /api/calls/{callId}/end` - Terminer un appel
  - `GET /api/calls/{callId}` - Récupérer un appel
  - `GET /api/calls/conversation/{conversationId}` - Liste des appels d'une conversation

#### 5. Modèles créés
- ✅ `Call` : Entité JPA (PostgreSQL)
- ✅ `CallStatus` : Enum (PENDING, ACCEPTED, REJECTED, ENDED, MISSED)
- ✅ `CallRequest` / `CallResponse` : DTOs avec `callerName`

#### 6. Sécurité
- ✅ Routes `/api/livekit/**` et `/api/calls/**` protégées dans `SecurityConfig`

### Backend ASP.NET Core ✅

#### 1. Hub SignalR
- ✅ `CallHub.cs` créé avec méthodes :
  - `RegisterUser(string userId)` - Enregistrer connexion utilisateur
  - `NotifyIncomingCall(string calleeId, object callData)` - Notifier appel entrant
  - `NotifyCallAccepted(string callerId, object callData)` - Notifier acceptation
  - `NotifyCallRejected(string callerId, string callId)` - Notifier refus
  - `NotifyCallEnded(string callId, List<string> participantIds)` - Notifier fin
- ✅ Mappé sur `/callhub` dans `Program.cs`

#### 2. Controller
- ✅ `CallController.cs` avec endpoints :
  - `POST /api/call/notify` - Notifier appel entrant (appelé par Spring Boot)
  - `POST /api/call/notify-accepted` - Notifier acceptation
  - `POST /api/call/notify-rejected` - Notifier refus

### Frontend Flutter ✅

#### 1. Dépendances
- ✅ `livekit_client: ^2.5.4` dans `pubspec.yaml`
- ✅ `signalr_netcore: ^1.4.4` dans `pubspec.yaml`

#### 2. Services créés
- ✅ `LiveKitApiService` : Récupération tokens depuis Spring Boot
- ✅ `LiveKitRoomService` : Gestion connexion/room LiveKit
- ✅ `CallService` : Gestion appels (start, accept, reject, end)
- ✅ `CallNotificationService` : Réception notifications SignalR

#### 3. Écrans créés
- ✅ `LiveKitCallScreen` : Écran d'appel vidéo/audio avec :
  - Affichage vidéo local et distant
  - Boutons contrôle (microphone, caméra, haut-parleur, fin)
  - Gestion des participants
  - États de connexion

#### 4. Widgets créés
- ✅ `CallIncomingDialog` : Dialog pour appels entrants (comme WhatsApp)

#### 5. Intégration dans ChatScreen
- ✅ Boutons appel audio/vidéo dans AppBar
- ✅ Gestion notifications d'appels entrants
- ✅ Navigation vers `LiveKitCallScreen`
- ✅ Méthodes `_startAudioCall()` et `_startVideoCall()`

#### 6. Modèle mis à jour
- ✅ `CallModel` adapté pour LiveKit avec `callerName`, `roomName`, `livekitUrl`

#### 7. Configuration
- ✅ Endpoints ajoutés dans `ApiConfig` :
  - `livekitTokenEndpoint()`
  - `callStartEndpoint`, `callAcceptEndpoint`, etc.
  - `signalRCallHubUrl`

## 📋 Flux complet d'un appel

### 1. Démarrage d'un appel (Caller)

```
1. User A clique sur bouton "Appel vidéo" dans ChatScreen
2. Flutter → POST /api/calls/start
   Body: { conversationId, calleeId, isVideoCall: true }
3. Spring Boot:
   - Crée Call en DB (status=PENDING)
   - Génère roomName = "within-{conversationId}"
   - Récupère callerName depuis UserRepository
   - Appelle CallNotificationService.notifyIncomingCall()
4. CallNotificationService → POST http://192.168.100.6:5000/api/call/notify
5. ASP.NET Core CallController → CallHub.NotifyIncomingCall()
6. SignalR → Envoie event "IncomingCall" à User B
7. Flutter (User B) → CallNotificationService.onIncomingCall callback
8. ChatScreen → Affiche CallIncomingDialog
```

### 2. Acceptation d'un appel (Callee)

```
1. User B clique "Accepter" dans CallIncomingDialog
2. Flutter → POST /api/calls/{callId}/accept
3. Spring Boot:
   - Met à jour Call (status=ACCEPTED)
   - Appelle CallNotificationService.notifyCallAccepted()
4. ASP.NET Core → SignalR → Notifie User A
5. Flutter (User A) → CallNotificationService.onCallAccepted callback
6. Les deux Flutter:
   - GET /api/livekit/token?room={roomName}&user={userId}
   - Reçoivent token JWT LiveKit
   - room.connect("ws://192.168.100.6:7880", token)
   - Naviguent vers LiveKitCallScreen
7. LiveKit gère transport audio/vidéo (SFU)
```

### 3. Refus d'un appel

```
1. User B clique "Refuser"
2. Flutter → POST /api/calls/{callId}/reject
3. Spring Boot → CallNotificationService.notifyCallRejected()
4. ASP.NET Core → SignalR → Notifie User A
5. User A voit notification "Appel refusé"
```

### 4. Fin d'un appel

```
1. User clique "Fin d'appel" dans LiveKitCallScreen
2. Flutter → POST /api/calls/{callId}/end
3. Spring Boot → Met à jour Call (status=ENDED)
4. LiveKitRoomService.disconnect()
5. Navigation retour vers ChatScreen
```

## 🔧 Configuration requise

### 1. LiveKit Server

**Déjà fait par vous** ✅

```bash
# Le serveur LiveKit doit tourner sur:
# ws://192.168.100.6:7880 (ou localhost:7880 pour émulateur)

# Credentials par défaut (dev):
# LIVEKIT_API_KEY=devkey
# LIVEKIT_API_SECRET=secret
```

### 2. Permissions Android

**Déjà configurées** ✅ dans `AndroidManifest.xml`:
- `android.permission.CAMERA`
- `android.permission.RECORD_AUDIO`
- `android.permission.INTERNET`

### 3. Configuration réseau

- **Spring Boot** : `http://192.168.100.6:8080`
- **ASP.NET Core** : `http://192.168.100.6:5000`
- **LiveKit Server** : `ws://192.168.100.6:7880`

## 🧪 Tests à effectuer

### Test 1 : Appel audio 1-to-1
1. User A démarre appel audio depuis ChatScreen
2. User B reçoit notification
3. User B accepte
4. Les deux se connectent à LiveKit
5. Vérifier audio fonctionne

### Test 2 : Appel vidéo 1-to-1
1. User A démarre appel vidéo
2. User B accepte
3. Vérifier vidéo locale et distante s'affichent
4. Tester toggle microphone/caméra

### Test 3 : Refus d'appel
1. User A démarre appel
2. User B refuse
3. Vérifier User A reçoit notification

### Test 4 : Fin d'appel
1. Appel en cours
2. Un utilisateur clique "Fin d'appel"
3. Vérifier retour à ChatScreen

## 🐛 Dépannage

### Problème : Token LiveKit invalide
- Vérifier `livekit.api.key` et `livekit.api.secret` dans `application-dev.properties`
- Vérifier que LiveKit server utilise les mêmes credentials
- Vérifier que le token n'a pas expiré (TTL=3600s = 1h)

### Problème : Pas de notification d'appel entrant
- Vérifier que ASP.NET Core est démarré sur port 5000
- Vérifier que `aspnet.core.url` est correct dans `application-dev.properties`
- Vérifier que `CallNotificationService.connect()` est appelé dans ChatScreen
- Vérifier les logs Spring Boot pour erreurs de notification

### Problème : Connexion LiveKit échoue
- Vérifier que LiveKit server est démarré
- Vérifier l'URL WebSocket (ws:// vs wss://)
- Vérifier les permissions réseau/firewall
- Vérifier les logs LiveKit server

### Problème : Pas de vidéo/audio
- Vérifier permissions caméra/microphone dans AndroidManifest.xml
- Vérifier que `setMicrophoneEnabled(true)` et `setCameraEnabled(true)` sont appelés
- Vérifier les logs LiveKit server
- Tester sur un vrai téléphone (émulateur peut avoir des limitations)

## 📝 Notes importantes

1. **Tokens LiveKit** : Toujours générés côté serveur (Spring Boot), jamais dans le client
2. **Sécurité** : Valider que l'utilisateur a le droit de rejoindre la room (participant de la conversation)
3. **TTL tokens** : 1h par défaut, ajustable dans `application-dev.properties`
4. **Room naming** : Format `within-{conversationId}` pour éviter les collisions
5. **SignalR** : Utilisé uniquement pour notifications, pas pour transport audio/vidéo (LiveKit gère ça)
6. **Notifications globales** : Actuellement dans ChatScreen, peut être déplacé dans MainNavigation pour notifications globales

## 🚀 Prochaines améliorations possibles

1. **Notifications globales** : Déplacer `CallNotificationService` dans `MainNavigation` pour recevoir appels même hors chat
2. **Appels de groupe** : Support multi-participants (LiveKit le supporte nativement)
3. **Enregistrement** : Activer enregistrement côté serveur LiveKit
4. **Statut d'appel** : Afficher "Appel en cours" dans la liste des conversations
5. **Historique d'appels** : Afficher les appels passés dans le profil utilisateur

## ✅ Checklist finale

- [x] LiveKit server téléchargé et démarré
- [x] Dépendances Spring Boot ajoutées
- [x] Services et controllers Spring Boot créés
- [x] Hub SignalR ASP.NET Core créé
- [x] Services Flutter créés
- [x] Écran d'appel Flutter créé
- [x] Intégration dans ChatScreen
- [x] Permissions Android configurées
- [x] Configuration réseau vérifiée
- [ ] Tests fonctionnels effectués
- [ ] Corrections bugs éventuels

## 📚 Documentation

- LiveKit Flutter SDK : https://docs.livekit.io/client-sdk-flutter/
- LiveKit Server : https://docs.livekit.io/server/
- SignalR .NET : https://docs.microsoft.com/en-us/aspnet/core/signalr/introduction

