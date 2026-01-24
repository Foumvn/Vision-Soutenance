
import requests
import time
import sys

BASE_URL = "http://localhost:8000/api"

USER1 = {"email": "u1@gmail.com", "password": "passwordu1", "full_name": "User One"}
USER4 = {"email": "u4@gmail.com", "password": "passwordu4", "full_name": "User Four"}

def register_if_needed(user):
    print(f"Checking/Registering {user['email']}...")
    # Try login first
    resp = requests.post(f"{BASE_URL}/auth/login", data={"username": user['email'], "password": user['password']})
    if resp.status_code == 200:
        print(f"User {user['email']} exists.")
        return resp.json()["access_token"]
    
    # Register
    print(f"Registering {user['email']}...")
    resp = requests.post(f"{BASE_URL}/auth/register", json={
        "email": user["email"],
        "password": user["password"],
        "full_name": user["full_name"],
        "role": "USER"
    })
    if resp.status_code == 200:
        print("Registered.")
        # Login to get token
        resp = requests.post(f"{BASE_URL}/auth/login", data={"username": user['email'], "password": user['password']})
        return resp.json()["access_token"]
    else:
        print(f"Failed to register {user['email']}: {resp.text}")
        return None

def get_user_id(email, token):
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(f"{BASE_URL}/users/search", params={"email": email}, headers=headers)
    if resp.status_code == 200:
        return resp.json()["_id"]
    return None

def main():
    # 1. Ensure User 4 exists (Receiver)
    token4 = register_if_needed(USER4)
    if not token4: sys.exit(1)
    
    # 2. Ensure User 1 exists (Sender)
    token1 = register_if_needed(USER1)
    if not token1: sys.exit(1)
    
    # 3. Get User 4 ID
    u4_id = get_user_id(USER4["email"], token1)
    if not u4_id:
        print("Could not find user 4 ID")
        sys.exit(1)
        
    print(f"User 4 ID: {u4_id}")
    
    print(">>> COMPLETE SETUP. WAITING 20 SECONDS BEFORE SENDING INVITE...")
    print(">>> GO LOGIN TO FRONTEND WITH u4@gmail.com / passwordu4 NOW <<<")
    
    time.sleep(20)
    
    print(">>> SENDING INVITATION NOW...")
    headers = {"Authorization": f"Bearer {token1}"}
    params = {"meeting_id": "meet-test-browser", "message": "Browser Test Invite"}
    url = f"{BASE_URL}/users/invite/{u4_id}"
    resp = requests.post(url, headers=headers, params=params)
    
    if resp.status_code == 200:
        print(">>> INVITATION SENT SUCCESSFULLY")
    else:
        print(f">>> FAILED TO SEND INVITATION: {resp.text}")

if __name__ == "__main__":
    main()
