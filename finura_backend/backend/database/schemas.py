from pydantic import BaseModel

# ---------- User ----------
class UserCreate(BaseModel):
    id: int
    pin_hash: str
    first_name: str
    last_name: str
    email: str
    occupation: str | None = None
    sex: str
    created_at: str
    user_photo: str | None = None

# ---------- Expense ----------
class ExpenseCreate(BaseModel):
    id: int
    user_id: int
    date: str
    day: int
    time: str
    mood: int
    description: str
    expense_amount: float

# ---------- Income ----------
class IncomeCreate(BaseModel):
    id: int
    user_id: int
    date: str
    day: int
    time: str
    mood: int
    description: str
    income_amount: float
