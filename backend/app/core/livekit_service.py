from livekit import api
from typing import Optional
import logging
from app.core.config import settings

logger = logging.getLogger(__name__)

class LiveKitService:
    def __init__(self):
        self.api_key = settings.LIVEKIT_API_KEY
        self.api_secret = settings.LIVEKIT_API_SECRET
        self.url = settings.LIVEKIT_URL
        
    def create_token(
        self, 
        room_name: str, 
        participant_identity: str,
        participant_name: Optional[str] = None,
        can_publish: bool = True,
        can_subscribe: bool = True,
        can_publish_data: bool = True
    ) -> str:
        """
        Crée un token JWT pour permettre à un utilisateur de rejoindre une room LiveKit
        
        Args:
            room_name: Nom de la room
            participant_identity: Identifiant unique du participant (user_id)
            participant_name: Nom d'affichage du participant
            can_publish: Peut publier audio/vidéo
            can_subscribe: Peut recevoir audio/vidéo
            can_publish_data: Peut envoyer des messages data
            
        Returns:
            Token JWT signé
        """
        try:
            # Créer l'access token
            token = api.AccessToken(self.api_key, self.api_secret)
            
            # Définir l'identité et le nom du participant
            token.with_identity(participant_identity)
            if participant_name:
                token.with_name(participant_name)
            
            # Définir les permissions pour la room
            token.with_grants(api.VideoGrants(
                room_join=True,
                room=room_name,
                can_publish=can_publish,
                can_subscribe=can_subscribe,
                can_publish_data=can_publish_data,
            ))
            
            # Générer le token JWT
            jwt_token = token.to_jwt()
            
            logger.info(f"Token créé pour {participant_identity} dans la room {room_name}")
            return jwt_token
            
        except Exception as e:
            logger.error(f"Erreur lors de la création du token: {str(e)}")
            raise Exception(f"Impossible de créer le token LiveKit: {str(e)}")
    
    def get_connection_url(self) -> str:
        """
        Retourne l'URL de connexion au serveur LiveKit
        """
        return self.url

# Instance singleton du service
livekit_service = LiveKitService()
