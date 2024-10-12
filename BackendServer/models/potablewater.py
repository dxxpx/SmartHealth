from flask import Flask, request, jsonify
import pickle
import pandas as pd

with open('potable_prediction.pkl', 'rb') as file:
    potable_water_model = pickle.load(file)

with open('predictive_model_final.pkl', 'rb') as file:
    predictive_model = pickle.load(file)

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get JSON data from request
        input_data = request.get_json()

        # Convert input JSON to DataFrame
        input_df = pd.DataFrame([input_data])

        # Make prediction
        prediction = potable_water_model.predict(input_df)[0]  # 0 or 1

        # Map prediction to human-readable output
        result = "Potable" if prediction == 1 else "Not potable"

        # Return JSON response
        return jsonify({
            "input": input_data,
            "result": result,
            "prediction": str(prediction) 
            })

    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/predictive-model', methods=['POST'])
def modelprediction():
    try:
        # Get JSON data from the request
        input_data = request.get_json()
        if not input_data:
            return jsonify({"error": "No input data provided"}), 400

        # Convert input to DataFrame
        input_df = pd.DataFrame(input_data)
        
        # Perform prediction
        prediction = predictive_model.predict(input_df)
        
        # Decode the numeric prediction to failure type
        failure_types = {0: "No Failure", 1: "Error"}
        decoded_prediction = [failure_types[pred] for pred in prediction]

        # Return the prediction as JSON response
        return jsonify({"prediction": decoded_prediction})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)