# ml_model/classifier.py
import joblib

# 🔥 Load  trained model
model = joblib.load("ml_model/classifier_model.pkl")

def predict_category(description: str) -> str:
    return model.predict([description])[0]
