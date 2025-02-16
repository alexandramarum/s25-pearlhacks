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

# 🔹 Exchange Public Token for Access Token
def exchange_public_token(db: Session, public_token: str, username: str):
    """Exchanges public token for an access token and saves it in the database."""
    response = requests.post(f"https://{PLAID_ENV}.plaid.com/item/public_token/exchange", json={
        "client_id": PLAID_CLIENT_ID,
        "secret": PLAID_SECRET,
        "public_token": public_token
    }).json()

    access_token = response.get("access_token")
    if not access_token:
        return {"error": "Failed to exchange public token"}

    # Save access_token for user
    db_user = db.query(User).filter(User.username == username).first()
    if db_user:
        db_user.plaid_access_token = access_token
        db.commit()

    return {"message": "Plaid account linked successfully", "access_token": access_token}


# 🔹 Fetch Account Balance & Determine Loan Pre-Approval
def get_loan_preapproval(db: Session, username: str):
    """Fetches financial data & calculates loan pre-approval."""
    db_user = db.query(User).filter(User.username == username).first()
    if not db_user or not db_user.plaid_access_token:
        return {"error": "No Plaid account linked"}

    # Fetch balance from Plaid
    response = requests.post(f"https://{PLAID_ENV}.plaid.com/accounts/balance/get", json={
        "client_id": PLAID_CLIENT_ID,
        "secret": PLAID_SECRET,
        "access_token": db_user.plaid_access_token
    }).json()

    balance = response["accounts"][0]["balances"]["available"]

    # Loan approval logic
    income = balance * 3  # Estimate income
    debt = balance * 0.5   # Estimate debt
    dti = (debt / max(1, income)) * 100

    if dti < 35 and balance > 1000:
        return {"approved": True, "approval_amount": income * 4, "message": "You are pre-approved!"}
    else:
        return {"approved": False, "message": "Not pre-approved. Try reducing debt."}
