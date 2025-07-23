# backend/models.py
from sqlalchemy import Column, Integer, String, Float, Text
from database import Base

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True, index=True)  # <-- keep same as SQLite
    pin_hash = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, nullable=False, unique=True)
    occupation = Column(String)
    sex = Column(String)
    created_at = Column(String)
    user_photo = Column(String)

class ExpenseEntry(Base):
    __tablename__ = 'expense_entry'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    date = Column(String, nullable=False)
    day = Column(Integer, nullable=False)
    time = Column(String, nullable=False)
    mood = Column(Integer)
    description = Column(Text)
    category = Column(String)
    expense_amount = Column(Float)

class IncomeEntry(Base):
    __tablename__ = 'income_entry'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    date = Column(String, nullable=False)
    day = Column(Integer, nullable=False)
    time = Column(String, nullable=False)
    mood = Column(Integer)
    description = Column(Text)
    category = Column(String)
    income_amount = Column(Float)
