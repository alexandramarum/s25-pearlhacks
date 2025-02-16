from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db import SessionLocal, User
import bcrypt, jwt, datetime
from dotenv import load_dotenv
import os

load_dotenv()
router = APIRouter()
SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_jwt_key")  # Default if .env is missing
ALGORITHM = "HS256"

# Get DB Session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Hash & Verify Passwords
def hash_password(password): return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
def verify_password(plain, hashed): return bcrypt.checkpw(plain.encode(), hashed.encode())

# Register User
@router.post("/register")
def register(username: str, password: str, db: Session = Depends(get_db)):
    if db.query(User).filter(User.username == username).first():
        raise HTTPException(status_code=400, detail="User already exists")
    user = User(username=username, password=hash_password(password))
    db.add(user)
    db.commit()
    return {"message": "User registered"}

# Login & Get JWT Token
@router.post("/token")
def login(username: str, password: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, user.password):
        raise HTTPException(status_code=400, detail="Invalid credentials")
    access_token = jwt.encode({"sub": username, "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=12)}, SECRET_KEY, algorithm=ALGORITHM)
    return {"access_token": access_token, "token_type": "bearer"}
