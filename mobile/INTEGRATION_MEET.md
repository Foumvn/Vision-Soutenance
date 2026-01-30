# Intégration Visio-conférence (LiveKit) - Mobile

Ce document explique les étapes suivies pour connecter le frontend Flutter Urbania au backend FastAPI et activer les fonctionnalités de visioconférence réelle.

## 1. Dépendances ajoutées
Nous avons installé les bibliothèques suivantes dans le projet mobile :
- `livekit_client` : Le SDK officiel pour la gestion des flux RTC (Audio/Vidéo).
- `http` : Pour les appels API vers le backend Urbania.
- `provider` : Pour la gestion d'état globale de la session de réunion.
- `permission_handler` : Pour gérer les accès Caméra et Micro.

## 2. Infrastructure de Services
- **`ApiService`** : Localisé dans `lib/services/api_service.dart`. Il gère les en-têtes d'authentification et centralise les requêtes vers le backend (URL configurée sur `10.0.2.2` pour l'émulateur Android).
- **`MeetingProvider`** : Localisé dans `lib/providers/meeting_provider.dart`. C'est le cœur de l'intégration. Il :
    - Récupère le jeton LiveKit auprès du backend Urbania (`/api/livekit/token`).
    - Initialise l'objet `Room` du client LiveKit.
    - Gère la publication des flux locaux et l'écoute des participants distants.

## 3. Flux de Connexion Rejoint
1. L'utilisateur clique sur "Rejoindre" dans `PreMeetingScreen`.
2. Le `MeetingProvider` appelle le backend avec le nom de la salle (`dev-team-sync` par défaut).
3. Le backend Urbania génère un JWT LiveKit signé.
4. Le client mobile utilise ce JWT pour se connecter aux serveurs LiveKit.
5. Une fois connecté, la navigation vers `MeetingScreen` est déclenchée.

## 4. Affichage Vidéo Dynamique
Dans `MeetingScreen`, nous avons remplacé les images statiques par des flux réels :
- **`VideoTrackRenderer`** : Composant LiveKit utilisé pour afficher les flux vidéo.
- **Gestion Auto** : Le système détecte automatiquement les nouveaux participants distants et les ajoute à la grille en temps réel via un `Consumer` de Provider.

## 5. Commandes de Contrôle
- **Microphone** : Le bouton Micro bascule l'état `setMicrophoneEnabled` sur le flux LiveKit réel.
- **Fin d'appel** : Le bouton rouge appelle `disconnect()` sur la Room et nettoie les ressources avant de fermer l'écran.

---
*Note: Pour tester sur un appareil physique, n'oubliez pas de mettre à jour l'IP du serveur dans `api_service.dart`.*
