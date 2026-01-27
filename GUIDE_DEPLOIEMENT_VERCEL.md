# 🚀 Guide de Déploiement : Frontend Vercel + Backend Local (ngrok)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         INTERNET                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐              ┌─────────────────────────────┐ │
│   │   Vercel     │              │     Votre Ordinateur        │ │
│   │  (Frontend)  │   ──────▶    │                             │ │
│   │   Next.js    │              │  ngrok ◀──▶ Backend:8000    │ │
│   └──────────────┘              └─────────────────────────────┘ │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📋 Étape 1 : Préparer votre Backend Local

### 1.1 Lancer le backend
```bash
# Depuis le dossier du projet
./start_all.sh
# OU manuellement
cd backend && uvicorn main:app --reload --port 8000
```

### 1.2 Lancer ngrok
```bash
# Utilisez le script fourni
./start_ngrok.sh

# OU manuellement
ngrok http 8000
```

Une fois lancé, vous obtiendrez une URL comme : `https://abc123.ngrok-free.app`

**⚠️ Important** : L'URL ngrok change à chaque redémarrage (version gratuite)

---

## 📋 Étape 2 : Configurer Vercel

### Option A : Via l'interface Web Vercel (Recommandé)

1. **Créer un compte** sur [vercel.com](https://vercel.com)

2. **Importer le projet**
   - Cliquez sur "New Project"
   - Connectez votre compte GitHub
   - Sélectionnez votre dépôt
   - Dans "Root Directory", sélectionnez : `web`

3. **Configurer les variables d'environnement**
   Avant de déployer, ajoutez cette variable :
   ```
   NEXT_PUBLIC_API_URL = https://VOTRE_URL_NGROK.ngrok-free.app
   ```

4. **Déployer**
   - Cliquez sur "Deploy"
   - Attendez la fin du build

### Option B : Via Vercel CLI

```bash
# Installer Vercel CLI
npm install -g vercel

# Se connecter
vercel login

# Depuis le dossier web/
cd web

# Premier déploiement (lien le projet)
vercel

# Déploiements suivants
vercel --prod
```

---

## 📋 Étape 3 : Configuration CORS du Backend

Assurez-vous que votre backend autorise les requêtes depuis Vercel.

Dans `backend/main.py`, vérifiez que CORS est configuré :

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",           # Dev local
        "https://votre-projet.vercel.app", # Production Vercel
        "https://*.vercel.app",            # Tous les déploiements Vercel
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 📋 Étape 4 : Workflow Quotidien

### Chaque fois que vous travaillez sur le projet :

1. **Lancer le backend**
   ```bash
   ./start_all.sh
   ```

2. **Lancer ngrok**
   ```bash
   ./start_ngrok.sh
   ```

3. **Copier l'URL ngrok**
   L'URL s'affiche dans le terminal

4. **Mettre à jour Vercel** (si l'URL a changé)
   - Allez dans les Settings de votre projet Vercel
   - Environment Variables
   - Modifiez `NEXT_PUBLIC_API_URL`
   - Redéployez le projet

### Pour automatiser (ngrok payant) :
Avec un compte ngrok payant, vous pouvez avoir une URL fixe :
```bash
ngrok http 8000 --domain=votre-domaine.ngrok.io
```

---

## 🔧 Dépannage

### L'URL ngrok ne fonctionne pas ?
- Vérifiez que le backend est lancé sur le port 8000
- Accédez à http://localhost:4040 pour voir les logs ngrok
- Testez l'URL directement dans le navigateur

### Erreur CORS ?
- Vérifiez la configuration CORS du backend
- Ajoutez l'URL Vercel dans `allow_origins`

### Le déploiement Vercel échoue ?
- Vérifiez les logs de build sur Vercel
- Assurez-vous que `npm run build` fonctionne localement
- Vérifiez que "Root Directory" est bien `web`

---

## 📁 Fichiers Créés

- `web/vercel.json` - Configuration Vercel
- `web/.env.example` - Exemple des variables d'environnement
- `start_ngrok.sh` - Script pour lancer ngrok
- `stop_ngrok.sh` - Script pour arrêter ngrok

---

## 🔗 Liens Utiles

- [Dashboard Vercel](https://vercel.com/dashboard)
- [Documentation Vercel](https://vercel.com/docs)
- [Interface ngrok locale](http://localhost:4040)
- [Dashboard ngrok](https://dashboard.ngrok.com)
