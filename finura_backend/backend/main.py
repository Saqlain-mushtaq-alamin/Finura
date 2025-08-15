from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

from backend.database import SessionLocal, engine  # from database/__init__.py
from backend.database import models             # triggers models import
from backend.database import crud, schemas         # same package
from backend.jobs.scheduler import start_scheduler

# Create tables once on startup
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Finura Backend")

# DB session dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.on_event("startup")
def startup_event():
    start_scheduler()

# -------------------- Endpoints --------------------
@app.post("/sync_user")
def sync_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    crud.create_user(db, user)
    return {"status": "ok", "item": "user"}

@app.post("/sync_expense")
def sync_expense(expense: schemas.ExpenseCreate, db: Session = Depends(get_db)):
    crud.create_expense(db, expense)
    return {"status": "ok", "item": "expense"}

@app.post("/sync_income")
def sync_income(income: schemas.IncomeCreate, db: Session = Depends(get_db)):
    crud.create_income(db, income)
    return {"status": "ok", "item": "income"}

#-----------for testing the code----------------------------
@app.get("/")
def root():
    return {"message": "Finura Backend is running"}

@app.get("/users")
def get_users(db: Session = Depends(get_db)):
    return db.query(models.User).all()

@app.get("/income")
def get_income(db: Session = Depends(get_db)):
    return db.query(models.IncomeEntry).all()
