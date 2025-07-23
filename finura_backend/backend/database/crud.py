# crud.py
from sqlalchemy.orm import Session
import models, schemas
from ml_models.classifier import predict_category



def create_user(db: Session, user: schemas.UserCreate):
    db_user = models.User(**user.dict())
    db.merge(db_user)  # handles insert or update by primary key
    db.commit()




def create_expense(db: Session, entry: schemas.ExpenseCreate):
    category = predict_category(entry.description)
    entry_data = entry.dict()
    entry_data["category"] = category
    db_expense = models.ExpenseEntry(**entry_data)
    db.merge(db_expense)
    db.commit()

def create_income(db: Session, entry: schemas.IncomeCreate):
    category = predict_category(entry.description)
    entry_data = entry.dict()
    entry_data["category"] = category
    db_income = models.IncomeEntry(**entry_data)
    db.merge(db_income)
    db.commit()
