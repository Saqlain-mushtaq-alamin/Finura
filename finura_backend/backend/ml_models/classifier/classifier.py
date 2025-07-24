# ml_model/classifier.py
import joblib

# 🔥 Load  trained model
vectorizer = joblib.load("ml_model/vectorizer.pkl")
model = joblib.load("ml_model/classifier_model.pkl")

def predict_category(description: str) -> str:
  
    # Transform the description using the loaded vectorizer
    transformed_description = vectorizer.transform([description])
    
    # Predict the category using the loaded model
    predicted_category = model.predict(transformed_description)
    
    return predicted_category[0]

    
