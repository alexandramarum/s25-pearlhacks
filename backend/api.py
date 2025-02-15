from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from db import get_db
import services

app = FastAPI()

# Register User
@app.post("/register")
def register(username: str, password: str, db: Session = Depends(get_db)):
    return services.register_user(db, username, password)

# Login User
@app.post("/token")
def login(username: str, password: str, db: Session = Depends(get_db)):
    return services.login_user(db, username, password)

# Create Plaid Link Token
@app.post("/create_link_token")
def create_link_token(token: str, db: Session = Depends(get_db)):
    username = services.get_current_user(token)
    return services.create_plaid_link_token(db, username)

# Loan Pre-Approval
@app.get("/loan_preapproval")
def loan_preapproval(token: str, db: Session = Depends(get_db)):
    username = services.get_current_user(token)
    return services.loan_preapproval(db, username)
