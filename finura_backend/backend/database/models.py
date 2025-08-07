from sqlalchemy import Column, ForeignKey, Integer, String, Float, Text
from . import Base  # imported from __init__.py

class User(Base):
    __tablename__ = "user"
    id = Column(String, primary_key=True, index=True)
    pin_hash = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, nullable=False, unique=True)
    occupation = Column(String)
    sex = Column(String)
    created_at = Column(String)
    user_photo = Column(String)

class ExpenseEntry(Base):
    __tablename__ = "expense_entry"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("user.id"), nullable=False)  # Changed from Integer
    date = Column(String, nullable=False)
    day = Column(Integer, nullable=False)
    time = Column(String, nullable=False)
    mood = Column(Integer)
    description = Column(Text)
    expense_amount = Column(Float)
    category = Column(String)  
    expense_amount = Column(Float)

class IncomeEntry(Base):
    __tablename__ = "income_entry"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("user.id"), nullable=False)  # Changed from Integer
    date = Column(String, nullable=False)
    day = Column(Integer, nullable=False)
    time = Column(String, nullable=False)
    mood = Column(Integer)
    description = Column(Text)
    income_amount = Column(Float)
    category = Column(String)  # <-- Optional



class SavingGoal(Base):
    __tablename__ = "saving_goal"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("user.id"), nullable=False)
    target_amount = Column(Float, nullable=False)
    frequency = Column(String, nullable=False)
    start_date = Column(String, nullable=False)
    end_date = Column(String)
    current_saved = Column(Float, default=0)
    description = Column(String)
   
class NoteEntry(Base):
    __tablename__ = "note_entry"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("user.id"), nullable=False)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(String, nullable=False)
    updated_at = Column(String, nullable=False)
