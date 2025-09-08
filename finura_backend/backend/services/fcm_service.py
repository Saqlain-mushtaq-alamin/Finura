# backend/services/fcm_service.py

import firebase_admin
from firebase_admin import credentials, messaging

cred = credentials.Certificate("firebase.json")
firebase_admin.initialize_app(cred)

def send_fcm_notification(token: str, title: str, body: str, data: dict = None):
    if not token:
        return None
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        token=token,
        data={k: str(v) for k, v in (data or {}).items()}
    )
    response = messaging.send(message)
    return response
     