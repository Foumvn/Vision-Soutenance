# 🎓 Tutoriel : Test du Système d'Authentification Urbania

Ce guide vous explique comment tester manuellement votre nouveau système d'authentification via l'interface interactive Swagger (OpenAPI).

## 🚀 Étape 1 : Accéder à l'interface de test

1.  Lancez votre serveur (si ce n'est pas déjà fait) :
    ```bash
    cd backend
    source venv/bin/activate
    python main.py
    ```
2.  Ouvrez votre navigateur sur : [http://localhost:8000/docs](http://localhost:8000/docs)

---

## 📝 Étape 2 : Créer un compte (Inscription)

1.  Recherchez la section **auth** et cliquez sur `POST /api/auth/register`.
2.  Cliquez sur le bouton **"Try it out"**.
3.  Modifiez le corps de la requête (Request body) avec des identifiants de test :
    ```json
    {
      "email": "votre@email.com",
      "password": "votre_mot_de_passe",
      "role": "USER",
      "language_preference": "fr"
    }
    ```
4.  Cliquez sur le gros bouton bleu **"Execute"**.
5.  **Succès** : Vous devriez recevoir un code `200` avec les détails de l'utilisateur créé (sans le mot de passe, par sécurité !).

---

## 🔑 Étape 3 : Se connecter (Login)

1.  Cliquez sur `POST /api/auth/login`.
2.  Cliquez sur **"Try it out"**.
3.  Remplissez les champs `username` (votre email) et `password`.
    > *Note : Cet endpoint utilise le format 'form-data' standard pour la compatibilité avec les outils d'authentification.*
4.  Cliquez sur **"Execute"**.
5.  **Succès** : Vous recevrez un `access_token` (JWT). Copiez ce jeton si vous voulez tester des routes protégées !

---

## 🛡️ Étape 4 : Utiliser le bouton "Authorize" (Optionnel)

Swagger permet de simuler une session connectée :
1.  En haut de la page, cliquez sur le bouton **"Authorize"** (avec le cadenas).
2.  Collez votre `access_token` dans le champ `value`.
3.  Cliquez sur **Authorize** puis **Close**.
4.  Désormais, toutes les requêtes que vous ferez vers des endpoints protégés incluront automatiquement votre jeton dans le header.

---

## 🛠️ Dépannage
- **Erreur 500** : Vérifiez que MongoDB est bien lancé (`docker compose up -d` ou service local).
- **Erreur 401** : Email ou mot de passe incorrect.
- **Port déjà utilisé** : Si le port 8000 est pris, vous pouvez le changer dans `main.py`.

Bravo ! Votre backend est prêt pour être connecté au frontend (Web ou Mobile).
