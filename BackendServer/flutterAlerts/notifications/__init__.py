import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate('notifications\\cerdentials\\serviceAccountKey.json')  # Update with your JSON filename
firebase_admin.initialize_app(cred)
