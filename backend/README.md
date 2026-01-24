# Urbania Backend API

Système d'authentification intégral basé sur FastAPI et MongoDB.

## Installation

1. Assurez-vous d'avoir Python 3.9+ installé.
2. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```
3. Configurez les variables d'environnement dans le fichier `.env`.

## Lancement de la base de données (MongoDB)

Utilisez Docker pour lancer l'instance MongoDB en une commande :
```bash
docker compose up -d
```

## Lancement du Backend

1. Activez l'environnement virtuel :
   ```bash
   source venv/bin/activate
   ```
2. Lancez le serveur :
   ```bash
   python main.py
   ```

## Structure
- `app/api`: Points d'entrée de l'API (Auth, etc.)
- `app/core`: Configuration et Sécurité (JWT, Hashing)
- `app/db`: Connexion MongoDB (Motor)
- `app/models`: Modèles de données Pydantic/BSON
