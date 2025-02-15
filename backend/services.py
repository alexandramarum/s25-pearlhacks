import bcrypt, jwt, datetime, requests, os
from sqlalchemy.orm import Session
from dotenv import load_dotenv
from db import User

# Load Environment Variables
load_dotenv()
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"
PLAID_CLIENT_ID = os.getenv("PLAID_CLIENT_ID")
PLAID_SECRET = os.getenv("PLAID_SECRET")
PLAID_ENV = os.getenv("PLAID_ENV", "sandbox")

# Hash & Verify Passwords
def hash_password(password): 
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

def verify_password(plain, hashed): 
    return bcrypt.checkpw(plain.encode(), hashed.encode())

# Generate JWT Token
def create_token(username): 
    return jwt.encode({"sub": username, "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=12)}, SECRET_KEY, algorithm=ALGORITHM)

# Decode JWT Token
def get_current_user(token): 
    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])["sub"]

# Register User
def register_user(db: Session, username: str, password: str):
    if db.query(User).filter(User.username == username).first():
        return {"error": "User already exists"}
    user = User(username=username, password=hash_password(password))
    db.add(user)
    db.commit()
    return {"message": "User registered"}

# Login User
def login_user(db: Session, username: str, password: str):
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, user.password):
        return {"error": "Invalid credentials"}
    return {"access_token": create_token(username), "token_type": "bearer"}

# Create Plaid Link Token
def create_plaid_link_token(db: Session, username: str):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        return {"error": "User not found"}

    response = requests.post(f"https://{PLAID_ENV}.plaid.com/link/token/create", json={
        "client_id": PLAID_CLIENT_ID,
        "secret": PLAID_SECRET,
        "user": {"client_user_id": username},
        "client_name": "Loan App",
        "products": ["transactions", "auth", "liabilities"],
        "country_codes": ["US"],
        "language": "en"
    }).json()
    return response

# Loan Pre-Approval Logic
def loan_preapproval(db: Session, username: str):
    return {"message": "Loan pre-approval logic coming soon!"}  # Placeholder
