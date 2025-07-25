"""
DB insert helpers.
Uses SQLAlchemy `merge()` so SQLite IDs are preserved (upsert style).
"""

from sqlalchemy.orm import Session

from . import models, schemas
from ..ml_models.classifier import predict_category


def create_user(db: Session, payload: schemas.UserCreate):
    db_user = models.User(**payload.dict())
    db.merge(db_user)
    db.commit()

def create_expense(db: Session, payload: schemas.ExpenseCreate):
    data = payload.dict()
    data["category"] = predict_category(data["description"])
    db_expense = models.ExpenseEntry(**data)
    db.merge(db_expense)
    db.commit()

def create_income(db: Session, payload: schemas.IncomeCreate):
    data = payload.dict()
    data["category"] = predict_category(data["description"])
    db_income = models.IncomeEntry(**data)
    db.merge(db_income)
    db.commit()
