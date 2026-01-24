from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum

class CallType(str, Enum):
    AUDIO = "audio"
    VIDEO = "video"

class CallStatus(str, Enum):
    PENDING = "pending"
    ACTIVE = "active"
    ENDED = "ended"
    REJECTED = "rejected"
    MISSED = "missed"

class RoomCreate(BaseModel):
    room_name: str
    participants: List[str]  # List of user IDs
    call_type: CallType = CallType.VIDEO

class RoomResponse(BaseModel):
    room_name: str
    created_at: datetime
    participants: List[str]
    call_type: CallType
    status: CallStatus

class TokenRequest(BaseModel):
    room_name: str
    user_id: str
    username: Optional[str] = None

class TokenResponse(BaseModel):
    token: str
    url: str
    room_name: str

class CallInvite(BaseModel):
    caller_id: str
    caller_name: str
    room_name: str
    call_type: CallType
    participants: List[str]

class CallAccept(BaseModel):
    room_name: str
    user_id: str

class CallReject(BaseModel):
    room_name: str
    user_id: str
    reason: Optional[str] = None
