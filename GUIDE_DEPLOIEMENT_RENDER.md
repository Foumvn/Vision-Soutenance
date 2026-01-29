# 🚀 Guide de Déploiement Complet sur Render (Gratuit)

Ce guide explique comment déployer gratuitement votre application (Frontend Next.js, Backend FastAPI, et Base de données MongoDB) en utilisant **Render** et **MongoDB Atlas**.

---

## 🏗️ Architecture de Production

*   **Frontend**: Render (Static Site ou Web Service)
*   **Backend**: Render (Web Service FastAPI)
*   **Base de données**: MongoDB Atlas (Cluster Gratuit)
*   **Visioconférence**: LiveKit Cloud (Projet Gratuit)

---

## 1️⃣ Étape 1 : Base de données (MongoDB Atlas)

Render ne propose pas de MongoDB gratuit. Nous utilisons **MongoDB Atlas**.

1.  Créez un compte gratuit sur [mongodb.com/atlas](https://www.mongodb.com/cloud/atlas/register).
2.  Créez un nouveau Cluster (choisissez l'offre **M0 Free**).
3.  Dans **Network Access**, ajoutez l'adresse IP `0.0.0.0/0` (pour autoriser Render).
4.  Dans **Database Access**, créez un utilisateur avec un mot de passe robuste.
5.  Cliquez sur **Connect** > **Drivers** > **Python** pour obtenir votre chaîne de connexion (URI).
    *   Exemple : `mongodb+srv://user:password@cluster.abc.mongodb.net/?retryWrites=true&w=majority`

---

## 2️⃣ Étape 2 : Visioconférence (LiveKit Cloud)

Héberger un serveur LiveKit sur Render Free est impossible. Utilisez la version Cloud gratuite.

1.  Créez un compte sur [livekit.io/cloud](https://livekit.io/cloud).
2.  Créez un nouveau projet.
3.  Récupérez vos identifiants dans les paramètres du projet :
    *   **LiveKit URL** (ex: `wss://project-xxx.livekit.cloud`)
    *   **API Key**
    *   **API Secret**

---

## 3️⃣ Étape 3 : Déployer le Backend sur Render

1.  Connectez-vous à [render.com](https://render.com).
2.  Cliquez sur **New +** > **Web Service**.
3.  Connectez votre dépôt GitHub.
4.  Configurez le service :
    *   **Name**: `votre-backend`
    *   **Environment**: `Python 3`
    *   **Root Directory**: `backend`
    *   **Build Command**: `pip install -r requirements.txt`
    *   **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
    *   **Instance Type**: `Free`
5.  Ajoutez les **Environment Variables** :
    *   `MONGODB_URL`: Votre URI MongoDB Atlas
    *   `DATABASE_NAME`: `urbania_db`
    *   `SECRET_KEY`: Une clé secrète aléatoire
    *   `LIVEKIT_URL`: Votre URL LiveKit Cloud
    *   `LIVEKIT_API_KEY`: Votre API Key LiveKit
    *   `LIVEKIT_API_SECRET`: Votre API Secret LiveKit

6.  Notez l'URL de votre backend une fois déployé (ex: `https://votre-backend.onrender.com`).

---

## 4️⃣ Étape 4 : Déployer le Frontend sur Render

1.  Cliquez sur **New +** > **Web Service** (ou Static Site si vous n'utilisez pas de SSR complexe).
2.  Configurez le service :
    *   **Name**: `votre-frontend`
    *   **Environment**: `Node`
    *   **Root Directory**: `web`
    *   **Build Command**: `npm install && npm run build`
    *   **Start Command**: `npm run start`
    *   **Instance Type**: `Free`
3.  Ajoutez les **Environment Variables** :
    *   `NEXT_PUBLIC_API_URL`: `https://votre-backend.onrender.com`
    *   `NEXT_PUBLIC_LIVEKIT_URL`: `wss://votre-projet.livekit.cloud` (votre URL LiveKit Cloud)

---

## ⚠️ Limitations de l'offre gratuite Render

1.  **Mise en veille** : Votre backend s'endort après 15 minutes sans requête. La première requête après une pause peut prendre 30 à 60 secondes pour "réveiller" le serveur.
2.  **Performance** : Les ressources (CPU/RAM) sont limitées.
3.  **Logs** : Les logs sont conservés sur une courte période.

---

## 🔧 Dépannage

### Problème de connexion MongoDB ?
Vérifiez que vous avez bien ajouté `0.0.0.0/0` dans **Network Access** sur MongoDB Atlas. Sans cela, Render ne pourra pas se connecter.

### Erreur CORS ?
Assurez-vous que votre backend autorise l'URL de votre frontend. En mode gratuit, vous pouvez laisser `allow_origins=["*"]` dans `backend/main.py` pour tester, puis restreindre plus tard.

### Le build échoue sur Render ?
Vérifiez que vos fichiers `package.json` (dans `web/`) et `requirements.txt` (dans `backend/`) sont bien à jour et présents dans les dossiers spécifiés.
