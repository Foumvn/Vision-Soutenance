from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Optional
from app.db.mongodb import get_database
from app.models.user import UserResponse, UserInDB, Notification, NotificationType
from app.api.endpoints.auth import get_current_user
from bson import ObjectId

import logging

logger = logging.getLogger(__name__)
router = APIRouter()
print("!!! USERS ENDPOINT MODULE LOADED !!!")

@router.get("/search", response_model=List[UserResponse])
async def search_user(query: Optional[str] = None, db = Depends(get_database)):
    if not query or len(query) < 2:
        return []
    
    # Recherche par email ou nom complet (insensible à la casse)
    cursor = db["users"].find({
        "$or": [
            {"email": {"$regex": query, "$options": "i"}},
            {"full_name": {"$regex": query, "$options": "i"}}
        ]
    }).limit(10)
    
    users = await cursor.to_list(length=10)
    return users

@router.post("/contacts/{contact_id}")
async def add_contact(
    contact_id: str, 
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    if contact_id == str(current_user.id):
        raise HTTPException(status_code=400, detail="Vous ne pouvez pas vous ajouter vous-même")
    
    # Try converting to ObjectId
    try:
        oid = ObjectId(contact_id)
    except:
        oid = contact_id

    # Check if contact exists
    contact_user = await db["users"].find_one({"_id": oid})
    if not contact_user:
        # Fallback to check if stored as string
        contact_user = await db["users"].find_one({"_id": contact_id})
        if not contact_user:
             raise HTTPException(status_code=404, detail="Utilisateur non présent")
    
    # Use standard ID string for storage in list to be consistent
    contact_id_str = str(contact_user["_id"])

    # Add to current user's contacts if not already there
    if contact_id_str not in current_user.contacts:
        try:
            current_oid = ObjectId(str(current_user.id))
        except:
            current_oid = current_user.id

        await db["users"].update_one(
            {"_id": current_oid},
            {"$push": {"contacts": contact_id_str}}
        )
        
    return {"message": "Contact ajouté avec succès"}

@router.post("/invite/{user_id}")
async def invite_user(
    user_id: str,
    meeting_id: str,
    message: str,
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    print(f"DEBUG: Inviting user_id={user_id} from sender={current_user.email}")

    # Try converting to ObjectId
    try:
        oid = ObjectId(user_id)
    except:
        oid = user_id

    # Check if target user exists
    target_user = await db["users"].find_one({"_id": oid})
    if not target_user:
         # Fallback
         target_user = await db["users"].find_one({"_id": user_id})
         if not target_user:
            print(f"DEBUG: User {user_id} not found")
            raise HTTPException(status_code=404, detail="Utilisateur non présent")
    
    print(f"DEBUG: Found target user {target_user.get('email')} with id {target_user.get('_id')}")

    notification = Notification(
        type=NotificationType.MEETING_INVITE,
        message=f"{current_user.full_name} vous a invité à une réunion: {message}",
        sender_id=str(current_user.id),
        meeting_id=meeting_id
    )
    
    result = await db["users"].update_one(
        {"_id": target_user["_id"]},
        {"$push": {"notifications": notification.dict()}}
    )
    
    print(f"DEBUG: Update result matched_count={result.matched_count} modified_count={result.modified_count}")

    if result.modified_count == 0:
        print("DEBUG: Warning - No document modified. Maybe notifications array didn't exist? (MongoDB push should handle this)")

    return {"message": "Invitation envoyée"}

@router.get("/me/notifications", response_model=List[Notification])
async def get_notifications(
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    print(f"DEBUG: get_notifications - current_user.id: {current_user.id}")
    # Fetch directly for comparison
    direct_user = await db.users.find_one({"_id": ObjectId(str(current_user.id))})
    direct_count = len(direct_user.get('notifications', [])) if direct_user else "USER NOT FOUND"
    print(f"DEBUG: Fetching notifications for {current_user.email}. Pydantic count: {len(current_user.notifications)}, Direct DB count: {direct_count}")
    return current_user.notifications

@router.get("/contacts", response_model=List[UserResponse])
async def get_contacts(
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    contact_ids = current_user.contacts
    if not contact_ids:
        return []
    
    contacts = await db["users"].find({"_id": {"$in": contact_ids}}).to_list(length=100)
    return contacts
@router.delete("/contacts/{contact_id}")
async def delete_contact(
    contact_id: str,
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    try:
        current_oid = ObjectId(str(current_user.id))
    except:
        current_oid = current_user.id

    await db["users"].update_one(
        {"_id": current_oid},
        {"$pull": {"contacts": contact_id}}
    )
    return {"message": "Contact supprimé"}

@router.post("/me/notifications/{notification_id}/read")
async def mark_notification_read(
    notification_id: str,
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    try:
        current_oid = ObjectId(str(current_user.id))
    except Exception:
        current_oid = current_user.id

    result = await db["users"].update_one(
        {"_id": current_oid},
        {"$pull": {"notifications": {"id": notification_id}}}
    )
    print(f"DEBUG: mark_notification_read - current_oid: {current_oid} ({type(current_oid)}), matched: {result.matched_count}")
    return {"message": "Notification supprimée"}

@router.post("/me/notifications/clear")
async def clear_notifications(
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    try:
        current_oid = ObjectId(str(current_user.id))
    except Exception:
        current_oid = current_user.id

    result = await db["users"].update_one(
        {"_id": current_oid},
        {"$set": {"notifications": []}}
    )
    print(f"DEBUG: clear_notifications - current_oid: {current_oid} ({type(current_oid)}), matched: {result.matched_count}")
    return {"message": "Toutes les notifications ont été supprimées"}
