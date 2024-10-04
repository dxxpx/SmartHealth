# -*- coding: utf-8 -*-
"""water_potability.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1__-5MJNG1MjcMq3RlpqQAZr1WB37PX7D
"""

import pickle
import modin.pandas as pd
from sklearnex import patch_sklearn
patch_sklearn(global_patch=True)
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import json
input_str = input("Enter a dictionary: ")
try:
    input_dict = json.loads(input_str)
    print(input_dict)
    print(type(input_dict))
    input_dict=pd.DataFrame(input_dict)
except json.JSONDecodeError:
    print("Invalid dictionary format. Please enter a valid JSON string.")
data = pd.read_csv("water_potability.csv")
df = data.dropna()

X = df[['ph', 'Hardness', 'Solids', 'Chloramines', 'Sulfate', 'Conductivity', 'Turbidity']]
y = df['Potability']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=63)

# Define the parameter grid
param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [None, 5, 10],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}

# Create the Random Forest model
rf_classifier = RandomForestClassifier(random_state=90)

# Create the GridSearchCV object
grid_search = GridSearchCV(estimator=rf_classifier, param_grid=param_grid, cv=5, scoring='accuracy')

# Fit the grid search to the data
grid_search.fit(X_train, y_train)

# Get the best parameters
best_params = grid_search.best_params_
print("Best parameters:", best_params)

# Train the model with the best parameters
best_rf_classifier = RandomForestClassifier(**best_params, random_state=90)
best_rf_classifier.fit(X_train, y_train)

# Make predictions and evaluate
y_pred_xgb = best_rf_classifier.predict(input_dict)
#accuracy = accuracy_score(y_test, y_pred)
#print("Accuracy:", accuracy)
if y_pred_xgb==0:
    print("Not potable")
else:
    print("Potable")
with open('potable_prediction.pkl', 'wb') as file:
    pickle.dump(best_rf_classifier, file)