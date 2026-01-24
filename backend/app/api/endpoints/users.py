from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Optional
from app.db.mongodb import get_database
from app.models.user import UserResponse, UserInDB, Notification, NotificationType
from app.api.endpoints.auth import get_current_user
from bson import ObjectId

router = APIRouter()

@router.get("/search", response_model=UserResponse)
async def search_user(email: str, db = Depends(get_database)):
    user = await db["users"].find_one({"email": email})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Utilisateur non présent"
        )
    return user

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
        await db["users"].update_one(
            {"_id": current_user.id},
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
async def get_notifications(current_user: UserInDB = Depends(get_current_user)):
    print(f"DEBUG: Fetching notifications for {current_user.email}. Count: {len(current_user.notifications)}")
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
    await db["users"].update_one(
        {"_id": current_user.id},
        {"$pull": {"contacts": contact_id}}
    )
    return {"message": "Contact supprimé"}

@router.post("/me/notifications/{notification_id}/read")
async def mark_notification_read(
    notification_id: str,
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    await db["users"].update_one(
        {"_id": current_user.id, "notifications.id": notification_id},
        {"$set": {"notifications.$.read": True}}
    )
    return {"message": "Notification marquée comme lue"}

@router.post("/me/notifications/clear")
async def clear_notifications(
    current_user: UserInDB = Depends(get_current_user),
    db = Depends(get_database)
):
    await db["users"].update_one(
        {"_id": current_user.id},
        {"$set": {"notifications.$[].read": True}}
    )
    return {"message": "Toutes les notifications ont été marquées comme lues"}
