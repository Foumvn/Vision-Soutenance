
import requests
import sys

BASE_URL = "http://localhost:8000/api"

# Configuration
USER1 = {"email": "u1@test.com", "password": "pass1", "full_name": "Fred One"}
USER2 = {"email": "u2@test.com", "password": "pass2", "full_name": "Fred Two"}

def register(user):
    print(f"[-] Registering {user['email']}...")
    resp = requests.post(f"{BASE_URL}/auth/register", json={
        "email": user["email"],
        "password": user["password"],
        "full_name": user["full_name"],
        "role": "USER",
        "language_preference": "fr" 
    })
    if resp.status_code == 200:
        print("    Success")
    elif resp.status_code == 400 and "already exists" in resp.text:
        print("    User already exists")
    else:
        print(f"    Failed: {resp.text}")
        sys.exit(1)

def login(user):
    print(f"[-] Logging in {user['email']}...")
    resp = requests.post(f"{BASE_URL}/auth/login", data={
        "username": user["email"],
        "password": user["password"]
    })
    if resp.status_code != 200:
        print(f"    Failed: {resp.text}")
        sys.exit(1)
    token = resp.json()["access_token"]
    print("    Success, token received")
    return token

def get_me(token):
    print("[-] Fetching user details...")
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(f"{BASE_URL}/auth/me", headers=headers)
    if resp.status_code != 200:
        print(f"    Failed: {resp.text}")
        sys.exit(1)
    return resp.json()

def invite(sender_token, target_id, meeting_id="meet-101", message="Join me now"):
    print(f"[-] Sending invitation to {target_id}...")
    headers = {"Authorization": f"Bearer {sender_token}"}
    params = {"meeting_id": meeting_id, "message": message}
    url = f"{BASE_URL}/users/invite/{target_id}"
    resp = requests.post(url, headers=headers, params=params)
    if resp.status_code != 200:
        print(f"    Failed: {resp.text}")
        sys.exit(1)
    print("    Invitation sent successfully")

def check_notifications(token, expected_meeting_id="meet-101"):
    print("[-] Checking notifications...")
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(f"{BASE_URL}/users/me/notifications", headers=headers)
    if resp.status_code != 200:
        print(f"    Failed: {resp.text}")
        sys.exit(1)
    
    notifications = resp.json()
    print(f"    Found {len(notifications)} notifications")
    
    found = False
    for notif in notifications:
        print(f"    - [{notif['type']}] {notif['message']} (Meeting: {notif.get('meeting_id')})")
        if notif.get("meeting_id") == expected_meeting_id:
            found = True
            
    if found:
        print("\n[SUCCESS] Invitation notification received verified!")
    else:
        print("\n[FAILURE] Expected notification not found.")
        sys.exit(1)

def main():
    # 1. Register users
    register(USER1)
    register(USER2)
    
    # 2. Login
    token1 = login(USER1)
    token2 = login(USER2)
    
    # 3. Get User 2 ID
    user2_details = get_me(token2)
    u2_id = user2_details["_id"]
    print(f"    User 2 ID: {u2_id}")
    
    # 4. U1 invites U2
    invite(token1, u2_id)
    
    # 5. U2 checks notifications
    check_notifications(token2)

if __name__ == "__main__":
    main()
