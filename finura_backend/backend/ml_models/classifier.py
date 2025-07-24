# ml_models/classifier.py
import joblib


# 🔥 Load  trained model
vectorizer = joblib.load("tfidf_vectorizer.joblib")
model = joblib.load("logistic_model.joblib")

def predict_category(description: str) -> str:
  
    # Transform the description using the loaded vectorizer
    transformed_description = vectorizer.transform([description])
    
    # Predict the category using the loaded model
    predicted_category = model.predict(transformed_description)
    
    return predicted_category[0]

    
