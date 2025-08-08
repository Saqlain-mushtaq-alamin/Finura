import tensorflow as tf

def load_model():
    return tf.keras.models.load_model("models/lstm_model.h5")
