from pydantic import BaseModel, EmailStr, Field, BeforeValidator
from typing import Optional, List, Annotated
from datetime import datetime
from enum import Enum
from bson import ObjectId

# Helper to handle MongoDB ObjectId
PyObjectId = Annotated[str, BeforeValidator(str)]

class Role(str, Enum):
    USER = "USER"
    ADMIN = "ADMIN"

class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None
    role: Role = Role.USER
    language_preference: str = "fr"

class UserCreate(UserBase):
    password: str

class NotificationType(str, Enum):
    MEETING_INVITE = "MEETING_INVITE"
    CONTACT_ADDED = "CONTACT_ADDED"
    SYSTEM = "SYSTEM"

class Notification(BaseModel):
    id: str = Field(default_factory=lambda: str(ObjectId()))
    type: NotificationType
    message: str
    sender_id: Optional[str] = None
    meeting_id: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    read: bool = False

class UserInDB(UserBase):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    hashed_password: str
    contacts: List[str] = [] # List of User IDs
    notifications: List[Notification] = []
    created_at: datetime = Field(default_factory=datetime.utcnow)

    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True

class UserResponse(UserBase):
    id: PyObjectId = Field(alias="_id")
    created_at: datetime

    class Config:
        populate_by_name = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

# Other entities based on architecture
class MeetingBase(BaseModel):
    title: str
    start_time: datetime
    end_time: Optional[datetime] = None

class MeetingInDB(MeetingBase):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    created_by: str # User ID
    created_at: datetime = Field(default_factory=datetime.utcnow)

class GroupBase(BaseModel):
    name: str
    description: Optional[str] = None

class GroupInDB(GroupBase):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    created_by: str # User ID
    members: List[str] = []
    created_at: datetime = Field(default_factory=datetime.utcnow)

class IAAgentBase(BaseModel):
    name: str
    capabilities: List[str] = ["STT", "summary", "vision"]

class IAAgentInDB(IAAgentBase):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    status: str = "active"
