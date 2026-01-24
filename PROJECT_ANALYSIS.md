# WithIn - Projet d'Application de Messagerie Complète (Version 1.1)

## 📋 Résumé Exécutif

**WithIn** est une plateforme de messagerie d'entreprise complète et moderne, conçue avec une architecture full-stack avancée. Le projet se compose d'une **API backend basée sur Spring Boot** robuste et sécurisée, d'un **backend ASP.NET Core pour les appels temps réel via SignalR/Jitsi**, d'un **frontend Flutter sophistiqué** multiplateforme, et d'une **infrastructure Docker cloud-native**. L'application offre une expérience utilisateur premium avec des fonctionnalités de messagerie avancées, gestion de contacts, partage de fichiers, **appels audio/vidéo via Jitsi Meet**, et communication temps réel.

**🎯 Version Actuelle**: 1.1.0 (Développement avancé - Frontend V1 + Appels Jitsi)
**📱 Platesformes Supportées**: Android, iOS, Web
**🏗️ Architecture**: Microservices avec Traefik Gateway + SignalR Hub

---

## 📊 POURCENTAGE DE DÉVELOPPEMENT GLOBAL

### **🎯 Score Total: 75%**

| Module | Progression | État |
|--------|-------------|------|
| **Backend Spring Boot API** | 90% | ✅ Quasi-complet |
| **Backend ASP.NET SignalR/Jitsi** | 75% | 🔄 Fonctionnel |
| **Frontend Flutter UI** | 85% | ✅ V1 Complète |
| **Infrastructure Docker** | 95% | ✅ Opérationnelle |
| **Sécurité de Base** | 80% | ✅ Fonctionnelle |
| **Communication Temps Réel** | 40% | 🔄 Partielle |
| **Appels Audio/Vidéo** | 75% | 🔄 Intégré |
| **Tests & Qualité** | 15% | ❌ À faire |
| **Documentation** | 70% | ✅ Bonne |
| **Production Ready** | 50% | 🔄 En cours |

### Détail par composant:

```
████████████████████░░░░░ 75% - DÉVELOPPEMENT GLOBAL

Backend Spring Boot:    ██████████████████░░ 90%
Backend ASP.NET Core:   ███████████████░░░░░ 75%
Frontend Flutter:       █████████████████░░░ 85%
Infrastructure Docker:  ███████████████████░ 95%
Sécurité:               ████████████████░░░░ 80%
Temps Réel (WebSocket): ████████░░░░░░░░░░░░ 40%
Appels Jitsi:           ███████████████░░░░░ 75%
Tests:                  ███░░░░░░░░░░░░░░░░░ 15%
Production:             ██████████░░░░░░░░░░ 50%
```

---

## 🏗️ Architecture Globale Complète

### Architecture Multi-Service (Configuration Actuelle)
```
📱 Client Flutter (iOS/Android/Web) - Version 3.6.0
    ↓ HTTPS/HTTP (Traefik v3.1)
🌐 Traefik API Gateway (Port 80, 8080 Dashboard)
    ↓ Load Balancing & Security
├── 🟢 Spring Boot API (Port 8080) - API REST principale
│   ↓ JWT + Redis Sessions (24h TTL)
│   ├── 🗄️ PostgreSQL 15 (Utilisateurs, Contacts)
│   ├── 📊 MongoDB 6.0 (Messages, Conversations)
│   └── 🔴 Redis 7 (Sessions, Cache, Email Tokens)
├── 🔵 ASP.NET Core (Port 5000) - SignalR Hub + Jitsi Controller ✅ ACTIF
│   ↓ WebSocket / SignalR
│   └── 📞 Jitsi Meet Integration (Appels Audio/Vidéo)
└── ☁️ MinIO Storage (Port 9000) - Médias et Fichiers partagés
    📧 Email Service (Gmail SMTP) - Notifications et vérifications
```

**📊 État des Services Backend**:
- ✅ **Spring Boot API**: Complète et opérationnelle (90%)
- ✅ **ASP.NET Core**: SignalR Hub + Jitsi Controller actifs (75%)
- ✅ **Gateway Traefik**: Configuration complète avec load balancing
- ✅ **Services Données**: Docker Compose opérationnel

### Structure du Projet (Version Actuelle)
```
WithIn/
├── backend/
│   ├── api-gateway/          # 📡 Traefik Configuration & Docker Compose
│   ├── spring-boot/          # ✅ API Principale (Spring Boot 3.5.7 - 90% Complète)
│   │   └── src/main/java/com/within/spring_boot/
│   │       ├── auth/         # ✅ Authentification JWT complète
│   │       ├── chat/         # ✅ Messages & Conversations
│   │       ├── contact/      # ✅ Gestion Contacts
│   │       ├── media/        # ✅ Upload/Download Médias
│   │       └── user/         # ✅ Gestion Utilisateurs
│   ├── aspnet-core/          # ✅ SignalR + Jitsi (75% Actif)
│   │   ├── Hubs/JitsiHub.cs  # ✅ Hub SignalR pour appels
│   │   ├── Controllers/CallController.cs # ✅ API Appels
│   │   └── Models/           # ✅ Modèles Call
│   ├── dotnet-app/           # ⚙️ .NET Console App (Démo)
│   └── shared/               # 🗄️ Services Docker Composés
├── frontend/
│   └── flutter_app/          # 📱 Application Mobile (Flutter 3.6.0 - 85% complète)
│       ├── lib/
│       │   ├── config/       # Configuration API multi-plateforme
│       │   ├── middleware/   # Auth Middleware
│       │   ├── models/       # 7 modèles de données (+ CallModel)
│       │   ├── screens/      # 15 écrans UI complets
│       │   ├── services/     # 13 services (+ CallService, JitsiService)
│       │   └── widgets/      # Widgets spécialisés (CallButton, CallIncoming)
│       └── pubspec.yaml      # Dépendances avec jitsi_meet_flutter_sdk
├── Entity.md                 # 📊 Diagramme d'Entités Complet
├── PROJECT_ANALYSIS.md       # 📋 Document d'Analyse (ce fichier)
└── ANALYSE_INTEGRATION_API.md # 📝 Documentation technique
```

**🔥 Derniers Commits Git**:
- `2086022` - Correction du systeme d'authentification cote frontend
- `b9926df` - Frontend V1_termine

---

## 🔧 Analyse Fonctionnelle Backend

### **1. Module Authentification & Sécurité (90% Complet)**

**🔐 Points forts identifiés :**
- ✅ **JWT robuste** avec validation Redis (24h TTL)
- ✅ **BCrypt** hashing pour mots de passe
- ✅ **Spring Security** configuration complète
- ✅ **CORS** configuré pour Flutter multiplateforme
- ✅ **Sessions stateless** avec Redis backend
- ✅ **Vérification email** via tokens Redis
- ✅ **Middleware Flutter** protection routes
- ✅ **Recherche utilisateur** par email ou username

**🚀 Fonctionnalités implémentées :**
- ✅ Inscription/connexion avec validation complète
- ✅ Vérification email via tokens Redis (24h TTL)
- ✅ Mot de passe oublié (tokens 15min)
- ✅ Déconnexion + mise hors ligne automatique
- ✅ Rôles admin avec endpoints protégés
- ✅ Recherche utilisateur full-text
- ✅ Gestion contacts CRUD avec notes personnelles

**📝 Code AuthService (extrait):**
```java
public LoginResponse login(LoginRequest request) {
    String loginIdentifier = request.getLoginIdentifier();
    Optional<User> userOpt = findUserByIdentifier(loginIdentifier);
    
    User user = userOpt.orElseThrow(() -> new RuntimeException("Identifiants invalides"));
    
    if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
        throw new RuntimeException("Identifiants invalides");
    }

    user.setOnline(true);
    user.setLastSeen(LocalDateTime.now());
    userRepository.save(user);

    String jwt = jwtService.generateToken(user);
    redisService.saveSession(jwt, user.getId());

    return new LoginResponse(jwt, user.getId(), user.getUsername(), user.getEmail());
}
```

### **2. Module Messagerie (Conversations & Messages) - 85% Complet**

**🗄️ Architecture MongoDB 6.0 optimisée :**
- **Conversations** : Support privé/groupe, soft delete, participants UUID
- **Messages** : Multi-média, statuts d'édition, horodatage précis
- **Index MongoDB** : Optimisé pour requêtes fréquentes

**📝 Fonctionnalités métier implémentées :**
- ✅ Création conversations (privées/groupes)
- ✅ Join/leave conversations
- ✅ Historique messages chronologique
- ✅ Gestion participants avec validation
- ✅ Metadonnées UI (lastMessage, lastUpdated)
- ✅ Marquer messages comme lus
- 🔄 WebSocket temps réel (partiel)

**📝 Code MessageService:**
```java
public Message sendMessage(String conversationId, UUID senderId, String content) {
    Conversation convo = conversationRepository.findById(conversationId)
        .orElseThrow(() -> new RuntimeException("Conversation introuvable"));

    Message msg = new Message();
    msg.setConversationId(conversationId);
    msg.setSenderId(senderId);
    msg.setContent(content);
    messageRepository.save(msg);

    convo.setLastMessage(content);
    convo.setLastUpdated(Instant.now());
    conversationRepository.save(convo);

    return msg;
}
```

### **3. Module Utilisateurs & Contacts - 95% Complet**

**🗄️ Modèle relationnel PostgreSQL 15 :**
- **Users** : UUID, unicité email/username, statut en ligne
- **Contacts** : Relations asymétriques, notes, favoris, historique

**🚀 Fonctionnalités avancées implémentées :**
- ✅ Recherche utilisateur full-text
- ✅ Gestion contacts avec notes personnelles
- ✅ Statistiques contacts (total/favoris)
- ✅ Validation existence utilisateur avant ajout
- ✅ Tracking dernier contact
- ✅ CRUD complet contacts
- ✅ Vérification si contact est utilisateur WithIn
- ✅ Compteurs contacts et favoris

**📝 Code ContactService (extrait):**
```java
public ContactResponse addContact(String userId, CreateContactRequest request) {
    if (!userRepository.existsById(userId)) {
        throw new RuntimeException("Utilisateur non trouvé");
    }

    if (contactRepository.existsByUserIdAndContactId(userId, request.getContactId())) {
        throw new RuntimeException("Ce contact existe déjà dans votre liste");
    }

    Contact contact = new Contact();
    contact.setUserId(userId);
    contact.setContactId(request.getContactId());
    contact.setContactName(request.getContactName());
    contact.setContactEmail(request.getContactEmail());
    contact.setAddedAt(LocalDateTime.now());

    return new ContactResponse(contactRepository.save(contact));
}
```

### **4. Module Appels Audio/Vidéo - 75% Complet** ⭐ NOUVEAU

**🔵 Backend ASP.NET Core + SignalR:**
- ✅ **JitsiHub** : Hub SignalR pour gestion appels temps réel
- ✅ **CallController** : API REST pour démarrer/notifier appels
- ✅ **Modèles** : CallRequest, CallResponse, CallStatus

**📞 Fonctionnalités Jitsi implémentées :**
- ✅ Démarrage appels audio/vidéo
- ✅ Notification appels entrants
- ✅ Gestion des participants (join/leave)
- ✅ État des appels actifs
- 🔄 Historique des appels (à implémenter)

**📝 Code JitsiHub (SignalR):**
```csharp
public class JitsiHub : Hub
{
    private static readonly Dictionary<string, List<string>> ActiveCalls = new();

    public async Task JoinCall(string conversationId, string userId)
    {
        if (!ActiveCalls.ContainsKey(conversationId))
            ActiveCalls[conversationId] = new List<string>();

        ActiveCalls[conversationId].Add(userId);

        await Clients.Group(conversationId).SendAsync("UserJoinedCall", new
        {
            UserId = userId,
            ConversationId = conversationId,
            Participants = ActiveCalls[conversationId]
        });

        await Groups.AddToGroupAsync(Context.ConnectionId, conversationId);
    }

    public async Task StartJitsiCall(string conversationId, string callerId, List<string> participants)
    {
        var jitsiRoom = $"within-{conversationId}";

        await Clients.Group(conversationId).SendAsync("JitsiCallStarted", new
        {
            ConversationId = conversationId,
            CallerId = callerId,
            Room = jitsiRoom,
            ServerUrl = "https://meet.jit.si",
            Participants = participants
        });
    }
}
```

**📝 Code CallController:**
```csharp
[HttpPost("start")]
public async Task<IActionResult> StartCall([FromBody] CallRequest request)
{
    var jitsiRoom = $"within-{request.ConversationId}";

    await _jitsiHub.Clients.Group(request.ConversationId)
        .SendAsync("JitsiCallStarted", new
        {
            ConversationId = request.ConversationId,
            CallerId = request.CallerId,
            Room = jitsiRoom,
            ServerUrl = "https://meet.jit.si",
            Participants = request.Participants,
            IsVideoCall = request.IsVideoCall
        });

    return Ok(new CallResponse { Room = jitsiRoom, ... });
}
```

### **5. Module Médias & Fichiers - 80% Configuré**

**☁️ Stockage MinIO S3-compatible :**
- ✅ Upload sécurisé avec validation types
- ✅ URLs signées pour sécurité
- ✅ Support avatars et pièces jointes
- ✅ Organisation par type de fichier
- ✅ Service Spring Boot complet

---

## 📱 Analyse Frontend Flutter (85% Complet)

### **1. Architecture Flutter Premium (Version 3.6.0)**

**🎯 Points forts identifiés :**
- ✅ **Material Design 3** implementation complète
- ✅ **Architecture propre** avec séparation modèles/services/UI
- ✅ **Multiplateforme** adaptative (Android/iOS/Web)
- ✅ **Animations fluides** avec controllers personnalisés
- ✅ **State management** robuste avec SharedPreferences
- ✅ **Intégration Jitsi Meet SDK** pour appels

**📱 Dépendances clés (pubspec.yaml):**
```yaml
dependencies:
  flutter: sdk: flutter
  shared_preferences: ^2.3.1      # Stockage local
  http: ^1.2.2                    # Client API
  flutter_overlay_window: ^0.5.0  # Bulle flottante
  permission_handler: ^11.3.1     # Permissions
  google_fonts: ^6.2.1            # Thème Material Design 3
  flutter_local_notifications: ^18.0.0  # Notifications
  jitsi_meet_flutter_sdk: git     # ✅ SDK Appels Vidéo
  webview_flutter: ^4.7.0         # WebView backup
```

### **2. Structure des Écrans (15 écrans)**

| Écran | Fichier | État |
|-------|---------|------|
| Splash | `splash_screen.dart` | ✅ Complet |
| Auth | `auth_screen.dart` | ✅ Complet |
| Login | `login_screen.dart` | ✅ Complet |
| Register | `register_screen.dart` | ✅ Complet |
| Admin Code | `admin_code_screen.dart` | ✅ Complet |
| Onboarding | `onboarding_screen.dart` | ✅ Complet |
| Main Nav | `main_navigation.dart` | ✅ Complet |
| Discussions | `discussions_screen.dart` | ✅ Complet |
| Chat | `chat_screen.dart` | ✅ Complet + Appels |
| Contacts | `contacts_screen.dart` | ✅ Complet |
| Files | `files_screen.dart` | ✅ Complet |
| Agenda | `agenda_screen.dart` | ✅ Complet |
| Profile | `profile_screen.dart` | ✅ Complet |
| Web Clipper | `web_clipper_screen.dart` | ✅ Complet |
| Overlay | `overlay_screen.dart` | ✅ Complet |

### **3. Structure des Services (13 services)**

| Service | Fichier | État |
|---------|---------|------|
| Auth | `auth_service.dart` | ✅ Complet |
| User | `user_service.dart` | ✅ Complet |
| Contact | `contact_service.dart` | ✅ Complet |
| Conversation | `conversation_service.dart` | ✅ Complet |
| Message | `message_service.dart` | ✅ Complet |
| File | `file_service.dart` | ✅ Complet |
| Media | `media_service.dart` | ✅ Complet |
| Task | `task_service.dart` | ✅ Complet |
| Clipper | `clipper_service.dart` | ✅ Complet |
| User Mapping | `user_mapping_service.dart` | ✅ Complet |
| **Call** | `call_service.dart` | ✅ **NOUVEAU** |
| **Jitsi** | `jitsi_service.dart` | ✅ **NOUVEAU** |

### **4. Structure des Modèles (7 modèles)**

| Modèle | Fichier | État |
|--------|---------|------|
| User | `user.dart` | ✅ Complet |
| Contact | `contact.dart` | ✅ Complet |
| Conversation | `conversation.dart` | ✅ Complet |
| Message | `message.dart` | ✅ Complet |
| FileItem | `file_item.dart` | ✅ Complet |
| Task | `task.dart` | ✅ Complet |
| **CallModel** | `call_model.dart` | ✅ **NOUVEAU** |

### **5. Widgets Spécialisés Appels** ⭐ NOUVEAU

**📞 CallButton Widget:**
```dart
class CallButton extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final String currentUserName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton appel audio
        IconButton(
          icon: Icon(Icons.call, color: Colors.green, size: 28),
          onPressed: () => _startAudioCall(context),
          tooltip: 'Appel audio',
        ),
        const SizedBox(width: 8),
        // Bouton appel vidéo
        IconButton(
          icon: Icon(Icons.video_call, color: Colors.blue, size: 28),
          onPressed: () => _startVideoCall(context),
          tooltip: 'Appel vidéo',
        ),
      ],
    );
  }
}
```

**📞 CallIncomingDialog Widget:**
```dart
class CallIncomingDialog extends StatefulWidget {
  final String conversationId;
  final String callerId;
  final String callerName;
  final bool isVideoCall;

  // Animation d'entrée élastique
  // Boutons Accepter/Refuser avec feedback visuel
  // Intégration JitsiService pour démarrer l'appel
}
```

### **6. JitsiService - Intégration Complète**

```dart
class JitsiService {
  static const String _serverUrl = "https://meet.jit.si";

  Future<void> startVideoCall({
    required String conversationId,
    required String callerId,
    required List<String> participants,
    required String callerName,
  }) async {
    await _checkPermissions();

    final options = JitsiMeetConferenceOptions(
      room: "within-${conversationId}-video-${DateTime.now().millisecondsSinceEpoch}",
      serverURL: _serverUrl,
      userInfo: JitsiMeetUserInfo(displayName: callerName),
    );

    await JitsiMeet().join(options);
  }

  Future<void> _checkPermissions() async {
    if (!kIsWeb) {
      await Permission.microphone.request();
      await Permission.camera.request();
    }
  }
}
```

### **7. Configuration API Multi-Plateforme**

```dart
class ApiConfig {
  // URLs par plateforme
  static const String _webUrl = 'http://localhost:5000';
  static const String _androidUrl = 'http://10.0.2.2:5000';
  static const String _iosUrl = 'http://localhost:5000';

  // Endpoints Appels
  static String get callEndpoint => '$effectiveUrl/api/call';
  static String get callStartEndpoint => '$effectiveUrl/api/call/start';
  static String get callNotifyEndpoint => '$effectiveUrl/api/call/notify';
  static String get callStatusEndpoint => '$effectiveUrl/api/call/status';
  static String get callAcceptEndpoint => '$effectiveUrl/api/call/accept';
  static String get callDeclineEndpoint => '$effectiveUrl/api/call/decline';
}
```

---

## 🐳 Infrastructure Docker (95% Opérationnelle)

### Architecture Docker Compose
```yaml
services:
  traefik:
    image: traefik:v3.1
    ports: ["80:80", "8080:8080"]
    
  springboot:
    build: ../spring-boot
    labels:
      - "traefik.http.routers.springboot.rule=PathPrefix(`/api`)"
      
  aspcore:
    build: ../aspcore
    labels:
      - "traefik.http.routers.aspcore.rule=PathPrefix(`/hub`)"
      
  postgres: image: postgres:15
  mongodb: image: mongo:6.0
  redis: image: redis:7
  minio: image: minio/minio
```

---

## 🔐 Analyse Sécurité

### **Points Forts ✅**
- JWT avec payload enrichi (userId, username, email)
- BCrypt hashage mots de passe (factor 10)
- Sessions Redis avec TTL automatique
- Input validation Jakarta Bean
- SQL injection protection JPA/Hibernate
- CORS configuré pour Flutter

### **Vulnérabilités Identifiées ⚠️**
- 🔴 **Secret JWT exposé** en clair dans config
- 🔴 **CORS trop permissif** pour production
- 🟡 **Pas de refresh token** système
- 🟡 **Pas de rate limiting** implémenté
- 🟡 **SharedPreferences non chiffré** côté mobile

---

## 📊 Analyse des Risques et Recommandations

### **Ce qui reste à faire (25% restant)**

#### Court Terme (Priorité Haute)
1. **Tests Unitaires** - Coverage à améliorer (actuellement ~15%)
2. **WebSocket Temps Réel** - Messagerie instantanée
3. **Push Notifications** - FCM/APNS intégration
4. **Variables d'environnement** - Sécuriser les secrets

#### Moyen Terme (Priorité Moyenne)
5. **Rate Limiting** - Protection API
6. **Monitoring** - Actuator + logging production
7. **Refresh Tokens** - Améliorer la sécurité JWT
8. **Historique Appels** - Logs des appels

#### Long Terme (Priorité Basse)
9. **Kubernetes** - Migration cloud
10. **Multi-tenant** - Support entreprise
11. **Analytics Dashboard** - Métriques utilisateurs

---

## 🎯 Roadmap Technique

### **Version 1.2 (Prochaine - Q1 2025)**
- [ ] WebSocket temps réel pour messagerie
- [ ] Push notifications (FCM/APNS)
- [ ] Historique des appels
- [ ] Tests unitaires backend (>60% coverage)
- [ ] Configuration production sécurisée

### **Version 2.0 (Q2-Q3 2025)**
- [ ] Appels de groupe (>2 participants)
- [ ] Partage d'écran
- [ ] Messages vocaux
- [ ] Réactions aux messages
- [ ] Mode hors ligne

### **Version 3.0 (2026+)**
- [ ] Microservices Kubernetes
- [ ] IA pour suggestions
- [ ] Transcription vocale
- [ ] End-to-end encryption
- [ ] Marketplace d'intégrations

---

## 📝 Conclusion - État du Projet

### **🎯 Pourcentage Global: 75%**

**WithIn** est un projet de messagerie d'entreprise bien avancé avec une architecture solide et des fonctionnalités modernes. L'ajout récent des **appels audio/vidéo via Jitsi Meet** représente une avancée significative vers une solution de communication unifiée.

### **Points Forts du Projet**
- ✅ Architecture multi-stack bien pensée (Spring Boot + ASP.NET + Flutter)
- ✅ Sécurité JWT avancée avec gestion sessions Redis
- ✅ Base de données hybride optimisée (PostgreSQL + MongoDB)
- ✅ Design Material Design 3 moderne
- ✅ **Appels audio/vidéo intégrés avec Jitsi** ⭐
- ✅ Configuration multi-environnement robuste
- ✅ Infrastructure Docker cloud-native

### **Technologies Utilisées**
| Couche | Technologies |
|--------|--------------|
| **Backend API** | Spring Boot 3.5.7, Java 17, PostgreSQL 15, MongoDB 6, Redis 7 |
| **Backend Temps Réel** | ASP.NET Core 8.0, SignalR, Jitsi Integration |
| **Frontend** | Flutter 3.6.0, Material Design 3, Jitsi Meet SDK |
| **Infrastructure** | Docker, Traefik v3.1, MinIO |
| **Sécurité** | JWT, BCrypt, CORS, Redis Sessions |

### **📊 Statut Développement**

```
┌─────────────────────────────────────────────────────────┐
│                    WithIn v1.1                          │
│                                                         │
│  Progression Globale: ████████████████████░░░░░ 75%     │
│                                                         │
│  ✅ Backend API Spring Boot      : Quasi-complet        │
│  ✅ Backend SignalR/Jitsi        : Fonctionnel          │
│  ✅ Frontend Flutter             : V1 Complète          │
│  ✅ Infrastructure Docker        : Opérationnelle       │
│  🔄 Communication Temps Réel     : Partielle            │
│  🔄 Appels Audio/Vidéo           : Intégré              │
│  ❌ Tests & Production           : À compléter          │
│                                                         │
│  Prochaine étape: WebSocket + Push Notifications        │
└─────────────────────────────────────────────────────────┘
```

---

*Dernière mise à jour: 1er Décembre 2025*
*Analysé par: Cursor AI Assistant*
