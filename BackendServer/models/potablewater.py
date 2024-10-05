import pickle
import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.ensemble import RandomForestClassifier
import json

data = pd.read_csv("C:\\Users\\Amrutha\\AndroidStudioProjects\\bitsnbytes\\HomeIQ - App\\smarthome\\my-node-backend\\datasets\\water_potability.csv")
df = data.dropna()

X = df[['ph', 'Hardness', 'Solids', 'Chloramines', 'Sulfate', 'Conductivity', 'Turbidity']]
y = df['Potability']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=63)

param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [None, 5, 10],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}


rf_classifier = RandomForestClassifier(random_state=90)
grid_search = GridSearchCV(estimator=rf_classifier, param_grid=param_grid, cv=5, scoring='accuracy')
grid_search.fit(X_train, y_train)

best_rf_classifier = grid_search.best_estimator_
with open('potable_prediction.pkl', 'wb') as file:
    pickle.dump(best_rf_classifier, file)

print("Model trained and saved successfully.")
