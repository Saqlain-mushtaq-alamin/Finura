"""
Loads TF‑IDF vectorizer + logistic model once and exposes predict_category()
Handles scikit‑learn version mismatches with a friendly warning.
"""

import warnings
import joblib
from pathlib import Path
from sklearn.exceptions import InconsistentVersionWarning

# Suppress noisy InconsistentVersionWarning (optional)
warnings.filterwarnings("ignore", category=InconsistentVersionWarning)

MODEL_DIR = Path(__file__).resolve().parent.parent / "models"

VECTORIZER_PATH = MODEL_DIR / "tfidf_vectorizer.joblib"
MODEL_PATH = MODEL_DIR / "logistic_model.joblib"

print(f"Loading vectorizer from: {VECTORIZER_PATH}")
print(f"Loading model      from: {MODEL_PATH}")

_vectorizer = joblib.load(VECTORIZER_PATH)
_model = joblib.load(MODEL_PATH)

def predict_category(description: str) -> str:
    X = _vectorizer.transform([description])
    return _model.predict(X)[0]
