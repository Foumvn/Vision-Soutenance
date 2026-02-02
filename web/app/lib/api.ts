
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

// Helper pour ajouter le header ngrok si nécessaire
const getHeaders = (headers: any = {}) => {
    return {
        ...headers,
        'ngrok-skip-browser-warning': 'true',
    };
};

export async function login(email: string, password: string): Promise<any> {
    const formData = new URLSearchParams();
    formData.append('username', email);
    formData.append('password', password);

    const response = await fetch(`${API_URL}/api/auth/login`, {
        method: 'POST',
        headers: getHeaders({
            'Content-Type': 'application/x-www-form-urlencoded',
        }),
        body: formData,
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Login failed');
    }

    return response.json();
}

export async function register(email: string, password: string, fullName: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/auth/register`, {
        method: 'POST',
        headers: getHeaders({
            'Content-Type': 'application/json',
        }),
        body: JSON.stringify({
            email,
            password,
            full_name: fullName,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Registration failed');
    }

    return response.json();
}

export async function getUserMe(token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/auth/me`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to fetch user');
    }

    return response.json();
}

export async function searchUser(query: string, token: string): Promise<any[]> {
    const response = await fetch(`${API_URL}/api/users/search?query=${encodeURIComponent(query)}`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Erreur lors de la recherche');
    }

    return response.json();
}

export async function addContact(contactId: string, token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/contacts/${contactId}`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to add contact');
    }

    return response.json();
}

export async function inviteUser(userId: string, meetingId: string, message: string, token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/invite/${userId}?meeting_id=${meetingId}&message=${encodeURIComponent(message)}`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to send invitation');
    }

    return response.json();
}

export async function getNotifications(token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/me/notifications`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
        cache: 'no-store',
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to fetch notifications');
    }

    return response.json();
}

export async function fetchContacts(token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/contacts`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to fetch contacts');
    }

    return response.json();
}

export async function removeContact(contactId: string, token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/contacts/${contactId}`, {
        method: 'DELETE',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to delete contact');
    }

    return response.json();
}

export async function markNotificationAsRead(notificationId: string, token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/me/notifications/${notificationId}/read`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to mark notification as read');
    }

    return response.json();
}

export async function clearAllNotifications(token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/users/me/notifications/clear`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        throw new Error('Failed to clear notifications');
    }

    return response.json();
}

// ============= LiveKit API Functions =============

export interface LiveKitTokenRequest {
    room_name: string;
    user_id: string;
    username?: string;
}

export interface LiveKitTokenResponse {
    token: string;
    url: string;
    room_name: string;
}

export interface RoomCreateRequest {
    room_name: string;
    participants: string[];
    call_type: 'audio' | 'video';
}

export async function getLiveKitToken(
    roomName: string,
    userId: string,
    username: string,
    token: string
): Promise<LiveKitTokenResponse> {
    const response = await fetch(`${API_URL}/api/livekit/token`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
        }),
        body: JSON.stringify({
            room_name: roomName,
            user_id: userId,
            username: username,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to get LiveKit token');
    }

    return response.json();
}

export async function createRoom(
    roomName: string,
    participants: string[],
    callType: 'audio' | 'video',
    token: string
): Promise<any> {
    const response = await fetch(`${API_URL}/api/livekit/rooms`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
        }),
        body: JSON.stringify({
            room_name: roomName,
            participants: participants,
            call_type: callType,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to create room');
    }

    return response.json();
}

export async function joinRoom(
    roomName: string,
    token: string
): Promise<any> {
    const response = await fetch(`${API_URL}/api/livekit/rooms/${roomName}/join`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to join room');
    }

    return response.json();
}

export async function leaveRoom(
    roomName: string,
    token: string
): Promise<any> {
    const response = await fetch(`${API_URL}/api/livekit/rooms/${roomName}/leave`, {
        method: 'POST',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to leave room');
    }

    return response.json();
}

export async function getRoomInfo(
    roomName: string,
    token: string
): Promise<any> {
    const response = await fetch(`${API_URL}/api/livekit/rooms/${roomName}`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to get room info');
    }

    return response.json();
}

export async function listMyRooms(token: string): Promise<any> {
    const response = await fetch(`${API_URL}/api/livekit/rooms`, {
        method: 'GET',
        headers: getHeaders({
            'Authorization': `Bearer ${token}`,
        }),
    });

    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = typeof errorData.detail === 'string'
            ? errorData.detail
            : JSON.stringify(errorData.detail);
        throw new Error(errorMessage || 'Failed to list rooms');
    }

    return response.json();
}

