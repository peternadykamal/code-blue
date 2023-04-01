import firebase_admin
from firebase_admin import credentials, db

cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(
    cred, {"databaseURL": "https://codeblue-482a2-default-rtdb.firebaseio.com/"})

ref = db.reference()
print(ref.get())
