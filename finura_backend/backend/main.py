# backend/main.py
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models, schemas, crud

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# ⛽ Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/sync_user")
def sync_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    crud.create_user(db, user)
    return {"message": "User synced!"}

@app.post("/sync_expense")
def sync_expense(expense: schemas.ExpenseCreate, db: Session = Depends(get_db)):
    crud.create_expense(db, expense)
    return {"message": "Expense synced!"}

@app.post("/sync_income")
def sync_income(income: schemas.IncomeCreate, db: Session = Depends(get_db)):
    crud.create_income(db, income)
    return {"message": "Income synced!"}
