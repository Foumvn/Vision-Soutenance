# Système de gestion des notifications

## Vue d'ensemble

Le système de notifications a été amélioré pour permettre le nettoyage côté frontend tout en préservant l'historique dans la base de données pour l'archivage.

## Architecture

### Backend (MongoDB)
- Les notifications sont **toujours conservées** dans la base de données
- Un champ `read: boolean` indique si une notification a été lue
- L'endpoint `/api/users/me/notifications/clear` marque toutes les notifications comme lues (`read: true`)
- Les notifications ne sont **jamais supprimées** physiquement de la BD

### Frontend
- Affiche **uniquement les notifications non lues** (`read: false`)
- Le bouton "Clear All" / "Dismiss" marque toutes les notifications comme lues
- Après nettoyage, les notifications disparaissent de l'interface
- Les nouvelles notifications apparaissent normalement

## Fonctionnalités implémentées

### 1. Dashboard - Section "Upcoming Meetings"

**Avant :**
- Affichait TOUTES les invitations (même déjà lues)
- Aucun moyen de nettoyer
- Encombrement de l'interface

**Après :**
- Affiche uniquement les invitations **non lues**
- Badge dynamique : "X New" (nombre d'invitations)
- Bouton "Clear All" pour marquer tout comme lu
- Animation de disparition fluide

**Code clé :**
```typescript
const unreadMeetingInvites = notifications.filter(
    n => n.type === "MEETING_INVITE" && !n.read
);
```

### 2. Bannière d'alerte de notifications

**Avant :**
- Bouton "View All" uniquement

**Après :**
- Bouton "Dismiss" pour nettoyer rapidement
- Bouton "View All" pour voir les détails
- Animation de disparition quand toutes les notifications sont lues

### 3. NotificationBell (composant)

**Déjà implémenté :**
- Filtrage automatique des notifications non lues
- Badge avec le nombre de notifications
- Bouton "Tout marquer comme lu" dans le panneau

## Flux de nettoyage

```
1. Utilisateur clique sur "Clear All" ou "Dismiss"
   ↓
2. Frontend appelle clearAllNotifications(token)
   ↓
3. Backend marque toutes les notifications comme read: true
   ↓
4. Frontend rafraîchit les notifications
   ↓
5. Le filtre (!n.read) masque les notifications lues
   ↓
6. L'interface se met à jour automatiquement
```

## Persistance pour archivage

Toutes les notifications restent dans MongoDB avec :
- `id` : Identifiant unique
- `type` : Type de notification (MEETING_INVITE, etc.)
- `message` : Contenu
- `sender_id` : Expéditeur
- `meeting_id` : Lien vers la réunion
- `created_at` : Date de création
- `read` : État de lecture (**false** = non lue, **true** = archivée)

Vous pouvez créer ultérieurement :
- Une page "Historique des notifications"
- Un export des notifications pour analyse
- Des statistiques sur les réunions passées

## API Endpoints utilisés

### 1. GET `/api/users/me/notifications`
Récupère toutes les notifications de l'utilisateur (lues et non lues).

**Réponse :**
```json
[
  {
    "id": "abc123",
    "type": "MEETING_INVITE",
    "message": "John vous a invité...",
    "meeting_id": "room-123",
    "read": false,
    "created_at": "2026-01-24T12:00:00Z"
  }
]
```

### 2. POST `/api/users/me/notifications/clear`
Marque toutes les notifications comme lues.

**Action :**
```javascript
await clearAllNotifications(token);
```

**Effet en BD :**
```mongodb
db.users.update(
  { _id: userId },
  { $set: { "notifications.$[].read": true } }
)
```

### 3. POST `/api/users/me/notifications/{id}/read`
Marque une notification spécifique comme lue.

## Utilisation

### Pour l'utilisateur final

1. **Voir les nouvelles notifications**
   - Badge rouge sur la cloche (en haut à droite)
   - Bannière d'alerte (si invitations de réunion)
   - Section "Upcoming Meetings" du dashboard

2. **Nettoyer les notifications**
   - Cliquer sur "Dismiss" (bannière)
   - Cliquer sur "Clear All" (section Upcoming Meetings)
   - Cliquer sur "Tout marquer comme lu" (panneau NotificationBell)

3. **Recevoir de nouvelles notifications**
   - Les nouvelles notifications apparaissent automatiquement
   - Polling toutes les 5 secondes (NotificationBell)
   - Rafraîchissement au chargement de page

### Pour les développeurs

**Ajouter un filtre personnalisé :**
```typescript
// Afficher uniquement les notifications de type X non lues
const myNotifs = notifications.filter(
    n => n.type === "MY_TYPE" && !n.read
);
```

**Créer une page d'historique :**
```typescript
// Afficher TOUTES les notifications (y compris archivées)
const allNotifs = notifications; // Ne pas filtrer par .read

// Afficher uniquement les notifications archivées
const archivedNotifs = notifications.filter(n => n.read);
```

## Améliorations futures possibles

1. **Archivage automatique**
   - Marquer automatiquement comme lu après 7 jours
   - Supprimer physiquement après 90 jours (RGPD)

2. **Catégories**
   - Filtrer par type (réunions, contacts, système)
   - Priorités (haute, normale, basse)

3. **Recherche**
   - Rechercher dans l'historique
   - Filtrer par date, expéditeur, type

4. **Statistiques**
   - Nombre d'invitations reçues/acceptées
   - Taux de participation aux réunions
   - Graphiques de l'activité

## Fichiers modifiés

1. **`/web/app/dashboard/page.tsx`**
   - Ajout de `fetchNotifications()` (fonction réutilisable)
   - Ajout de `handleClearNotifications()`
   - Filtrage des notifications non lues
   - Boutons de nettoyage

2. **`/web/components/ui/NotificationBell.tsx`** (déjà fait)
   - Filtrage ligne 73 : `notifications.filter(n => !n.read)`
   - Fonction `handleClearAll()` ligne 50-59

3. **`/backend/app/api/endpoints/users.py`** (déjà fait)
   - Endpoint `/me/notifications/clear` ligne 141-150
   - Utilise `$set` MongoDB pour marquer comme lu

## Tests recommandés

1. ✅ Créer une notification
2. ✅ Vérifier qu'elle apparaît
3. ✅ Cliquer sur "Clear All"
4. ✅ Vérifier que la notification disparaît de l'UI
5. ✅ Vérifier dans MongoDB que `read: true`
6. ✅ Créer une nouvelle notification
7. ✅ Vérifier qu'elle apparaît normalement
