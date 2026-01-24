from fastapi import APIRouter, HTTPException, Depends, status
from typing import List, Dict
from app.models.livekit import (
    TokenRequest, 
    TokenResponse, 
    RoomCreate, 
    RoomResponse,
    CallInvite,
    CallStatus,
    CallType
)
from app.core.livekit_service import livekit_service
from app.api.deps import get_current_user
from datetime import datetime
from app.db.mongodb import get_database
from app.models.user import Notification, NotificationType, UserInDB
from bson import ObjectId
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

# Storage temporaire pour les rooms (à remplacer par MongoDB en production)
active_rooms: Dict[str, dict] = {}

@router.post("/token", response_model=TokenResponse)
async def get_livekit_token(
    request: TokenRequest,
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Génère un token LiveKit pour rejoindre une room
    """
    try:
        # Utiliser l'ID de l'utilisateur
        user_id = request.user_id or str(current_user.id)
        username = request.username or current_user.full_name or current_user.email
        
        # Générer le token LiveKit
        token = livekit_service.create_token(
            room_name=request.room_name,
            participant_identity=user_id,
            participant_name=username
        )
        
        # Retourner le token et l'URL de connexion
        return TokenResponse(
            token=token,
            url=livekit_service.get_connection_url(),
            room_name=request.room_name
        )
        
    except Exception as e:
        logger.error(f"Erreur génération token: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur lors de la génération du token: {str(e)}"
        )

@router.post("/rooms", response_model=RoomResponse)
async def create_room(
    room: RoomCreate,
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    """
    Crée une nouvelle room de communication
    """
    try:
        user_id = str(current_user.id)
        
        # Vérifier si la room existe déjà
        if room.room_name in active_rooms:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cette room existe déjà"
            )
        
        # Créer la room
        room_data = {
            "room_name": room.room_name,
            "created_at": datetime.utcnow(),
            "created_by": user_id,
            "participants": room.participants,
            "call_type": room.call_type,
            "status": CallStatus.PENDING
        }
        
        active_rooms[room.room_name] = room_data

        # Envoyer des invitations aux participants (sauf le créateur)
        for participant_id in room.participants:
            if participant_id != str(current_user.id):
                try:
                    # Convertir en ObjectId si nécessaire
                    try:
                        target_oid = ObjectId(participant_id)
                    except:
                        target_oid = participant_id

                    notification = Notification(
                        type=NotificationType.MEETING_INVITE,
                        message=f"{current_user.full_name or current_user.email} vous invite à une visioconférence",
                        sender_id=str(current_user.id),
                        meeting_id=room.room_name # Le nom de la room sert d'ID ici
                    )

                    await db["users"].update_one(
                        {"_id": target_oid},
                        {"$push": {"notifications": notification.dict()}}
                    )
                    logger.info(f"Invitation envoyée à {participant_id}")
                except Exception as notify_err:
                    logger.error(f"Erreur envoi notification à {participant_id}: {notify_err}")
        
        logger.info(f"Room créée: {room.room_name} par {user_id}")
        
        return RoomResponse(**room_data)
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Erreur création room: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur lors de la création de la room: {str(e)}"
        )

@router.get("/rooms/{room_name}", response_model=RoomResponse)
async def get_room(
    room_name: str,
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Récupère les informations d'une room
    """
    if room_name not in active_rooms:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Room non trouvée"
        )
    
    return RoomResponse(**active_rooms[room_name])

@router.get("/rooms", response_model=List[RoomResponse])
async def list_rooms(
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Liste toutes les rooms actives
    """
    user_id = str(current_user.id)
    
    # Filtrer les rooms où l'utilisateur est participant
    user_rooms = [
        RoomResponse(**room_data)
        for room_data in active_rooms.values()
        if user_id in room_data.get("participants", []) or 
           room_data.get("created_by") == user_id
    ]
    
    return user_rooms

@router.post("/rooms/{room_name}/join")
async def join_room(
    room_name: str,
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Rejoindre une room existante
    """
    if room_name not in active_rooms:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Room non trouvée"
        )
    
    user_id = str(current_user.id)
    room_data = active_rooms[room_name]
    
    # Ajouter l'utilisateur aux participants s'il n'y est pas déjà
    if user_id not in room_data["participants"]:
        room_data["participants"].append(user_id)
    
    # Mettre à jour le status à ACTIVE
    room_data["status"] = CallStatus.ACTIVE
    
    logger.info(f"Utilisateur {user_id} a rejoint la room {room_name}")
    
    return {"message": "Room rejointe avec succès", "room_name": room_name}

@router.post("/rooms/{room_name}/leave")
async def leave_room(
    room_name: str,
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Quitter une room
    """
    if room_name not in active_rooms:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Room non trouvée"
        )
    
    user_id = str(current_user.id)
    room_data = active_rooms[room_name]
    
    # Retirer l'utilisateur des participants
    if user_id in room_data["participants"]:
        room_data["participants"].remove(user_id)
    
    # Si plus de participants, fermer la room
    if len(room_data["participants"]) == 0:
        room_data["status"] = CallStatus.ENDED
        logger.info(f"Room {room_name} fermée (plus de participants)")
    
    logger.info(f"Utilisateur {user_id} a quitté la room {room_name}")
    
    return {"message": "Room quittée avec succès"}

@router.delete("/rooms/{room_name}")
async def delete_room(
    room_name: str,
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Supprimer une room (seulement pour le créateur)
    """
    if room_name not in active_rooms:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Room non trouvée"
        )
    
    user_id = str(current_user.id)
    room_data = active_rooms[room_name]
    
    # Vérifier que l'utilisateur est le créateur
    if room_data.get("created_by") != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seul le créateur peut supprimer la room"
        )
    
    # Supprimer la room
    del active_rooms[room_name]
    
    logger.info(f"Room {room_name} supprimée par {user_id}")
    
    return {"message": "Room supprimée avec succès"}
