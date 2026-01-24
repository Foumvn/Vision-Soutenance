# Corrections apportées au système de visioconférence

## Date : 2026-01-24

## Problèmes identifiés et corrigés

### 1. **Erreur `[object Object]` lors de la création de réunion**

**Problème** : Le frontend affichait `[object Object]` au lieu d'un message d'erreur lisible.

**Cause** : FastAPI retourne parfois des détails d'erreur sous forme d'objets/tableaux (pour les erreurs de validation Pydantic), et le frontend essayait de les afficher directement.

**Solution** : 
- Modifié `web/app/lib/api.ts` pour détecter si `errorData.detail` est un objet
- Si c'est le cas, le convertir en chaîne JSON avec `JSON.stringify()`
- Appliqué cette logique à **tous** les appels API

**Fichiers modifiés** :
- `/web/app/lib/api.ts` : Toutes les fonctions API

---

### 2. **Erreur `Input should be a valid string` (participants null)**

**Problème** : Le backend recevait `null` dans la liste des participants lors de la création d'une room.

**Cause** : 
- MongoDB retourne `_id` comme identifiant
- Le frontend utilisait `contact.id` qui était `undefined` pour certains utilisateurs
- Les valeurs `undefined` étaient envoyées au backend et interprétées comme `null`

**Solution** :
- Uniformisation de la récupération d'ID : `contact.id || contact._id`
- Ajout d'un filtre avant l'envoi : `.filter(id => !!id && typeof id === 'string')`
- Vérifications de sécurité avec messages d'erreur clairs

**Fichiers modifiés** :
- `/web/app/meeting/pre-join/page.tsx` : 
  - Ligne 64-67 : Filtrage des participants
  - Ligne 224-234 : Gestion de la recherche d'utilisateur
  - Ligne 272-302 : Affichage des contacts avec ID unifié

---

### 3. **Erreur `Field required: user_id`**

**Problème** : L'endpoint `/api/livekit/token` recevait `{"room_name":"...","username":"..."}` sans `user_id`.

**Cause** :
- Dans `room/page.tsx`, on envoyait `userData.id` qui était `undefined`
- Le backend attendait `user_id` comme champ requis

**Solution** :
- Ajout de la gestion `userData.id || userData._id` dans `room/page.tsx`
- Vérification explicite avec message d'erreur si l'ID n'existe pas

**Fichiers modifiés** :
- `/web/app/meeting/room/page.tsx` : Ligne 45-60

---

### 4. **Erreur 500 Internal Server Error dans `/join`**

**Problème** : `current_user.get("user_id")` échouait car `current_user` était de type `UserInDB` (objet Pydantic) et non `dict`.

**Cause** : Incohérence dans le typage des endpoints backend - certains utilisaient `dict` au lieu de `UserInDB`.

**Solution** :
- Correction de **tous** les endpoints dans `livekit.py` pour utiliser `UserInDB`
- Remplacement de tous les `.get("user_id")` par `str(current_user.id)`

**Fichiers modifiés** :
- `/backend/app/api/endpoints/livekit.py` :
  - Ligne 27-37 : `get_livekit_token`
  - Ligne 60-70 : `create_room`
  - Ligne 101-143 : `get_room`
  - Ligne 145-162 : `list_rooms`
  - Ligne 164-190 : `join_room`
  - Ligne 192-220 : `leave_room`
  - Ligne 222-251 : `delete_room`

---

### 5. **Notifications non envoyées lors de la création d'une room**

**Problème** : Les participants invités ne recevaient pas de notification.

**Cause** : L'endpoint `POST /api/livekit/rooms` créait la room mais n'envoyait aucune notification.

**Solution** :
- Ajout d'une boucle parcourant tous les participants (sauf le créateur)
- Création d'une `Notification` de type `MEETING_INVITE` pour chacun
- Insertion dans la base de données MongoDB

**Fichiers modifiés** :
- `/backend/app/api/endpoints/livekit.py` : Ligne 91-107

---

### 6. **Liens de notification incorrects**

**Problème** : Les notifications pointaient vers `/meeting/pre-join` au lieu de la page pour rejoindre l'appel.

**Solution** :
- Modification des liens pour utiliser `/meeting/invite?room={meeting_id}`
- Le paramètre `room` est extrait du `meeting_id` de la notification

**Fichiers modifiés** :
- `/web/components/ui/NotificationBell.tsx` : Ligne 169
- `/web/app/dashboard/page.tsx` : Ligne 110

---

## Résumé des modifications par fichier

### Backend
1. **`/backend/app/api/endpoints/livekit.py`**
   - Import de `get_database`, `Notification`, `NotificationType`, `UserInDB`
   - Typage correct de tous les endpoints avec `UserInDB`
   - Ajout de l'envoi de notifications lors de la création de room
   - Correction de l'accès à l'ID utilisateur

### Frontend
1. **`/web/app/lib/api.ts`**
   - Gestion robuste des erreurs API (objets/tableaux)

2. **`/web/app/meeting/pre-join/page.tsx`**
   - Gestion uniforme des IDs (`id` ou `_id`)
   - Filtrage des participants invalides
   - Validation avant envoi

3. **`/web/app/meeting/room/page.tsx`**
   - Extraction sécurisée de l'ID utilisateur
   - Message d'erreur clair si ID manquant

4. **`/web/components/ui/NotificationBell.tsx`**
   - Lien correct vers la page d'invitation

5. **`/web/app/dashboard/page.tsx`**
   - Lien correct vers la page d'invitation

---

## Tests recommandés

1. ✅ Créer une room avec plusieurs participants
2. ✅ Vérifier que les notifications sont reçues
3. ✅ Cliquer sur "Accepter" dans une notification
4. ✅ Rejoindre une room
5. ✅ Vérifier le token LiveKit
6. ✅ Tester avec différents utilisateurs

---

## État actuel

Le système fonctionne maintenant correctement :
- ✅ Création de room sans erreur
- ✅ Envoi de notifications aux participants
- ✅ Réception des invitations
- ✅ Liens fonctionnels dans les notifications
- ✅ Connexion à la room LiveKit

**Logs backend montrent** :
- Appels réussis (200 OK) pour la création de room
- Appels réussis (200 OK) pour l'obtention de token LiveKit
- Notifications visibles pour les utilisateurs invités
