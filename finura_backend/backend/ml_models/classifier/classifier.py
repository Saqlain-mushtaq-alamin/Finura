# ml_model/classifier.py
import joblib
import os

base_path = os.path.dirname(os.path.abspath(__file__))  # points to classifier.py

vectorizer_path = os.path.join(base_path, "..", "ml_model", "tfidf_vectorizer.joblib")
model_path = os.path.join(base_path, "..", "ml_model", "logistic_model.joblib")

vectorizer_path = os.path.normpath(vectorizer_path)
model_path = os.path.normpath(model_path)

print(f"Loading vectorizer from: {vectorizer_path}")
print(f"Loading model from: {model_path}")

vectorizer = joblib.load(vectorizer_path)
model = joblib.load(model_path)
def predict_category(description: str) -> str:
  
    # Transform the description using the loaded vectorizer
    transformed_description = vectorizer.transform([description])
    
    # Predict the category using the loaded model
    predicted_category = model.predict(transformed_description)
    
    return predicted_category[0]

    
