import hmac
import hashlib

# Set the registration shared secret from homeserver.yaml
shared_secret = b"6Z0fBGL0DD#fv@BJmhR7~3zZrMgYKjkjCi.G2,~f4qXxm;3PK@"

# Define the registration details
nonce = "c9b44189a131b9efa43ec3b64467c622591a6bb4d47d2a515ebc259219288ccc35a01758e995c7a16eaba019d1b1bb98c7d1540b44c3bfc0c29288611d1838df"
username = "john.doe"
password = "test1234"
admin = False  # Set to True if the user should be an admin

def generate_mac(nonce, user, password, admin=False, user_type=None):
    mac = hmac.new(
        key=shared_secret,
        digestmod=hashlib.sha1,
    )

    mac.update(nonce.encode('utf8'))
    mac.update(b"\x00")
    mac.update(user.encode('utf8'))
    mac.update(b"\x00")
    mac.update(password.encode('utf8'))
    mac.update(b"\x00")
    mac.update(b"admin" if admin else b"notadmin")
    
    if user_type:
        mac.update(b"\x00")
        mac.update(user_type.encode('utf8'))

    return mac.hexdigest()

# Generate the MAC
mac = generate_mac(nonce, username, password, admin)

print("Generated MAC:", mac)
