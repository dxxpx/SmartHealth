The intel libraries used are:-
 1) tensorflow-intel, imported normally as tensorflow
 2) scikit-learn-intelex, patched globally
 3) modin imported as modin.pandas
 4) Intel Math Kernel accelerated Numpy, imported normally as Numpy.
    
The models with trained data is saved as pickle file while also uploaded as .py and .ipynb file along with their corresponding datasets
Algorithms used - 
1) XGBoostClassifier with gridsearchcv to find best hyperparameters
2) Random Forest Classifier with gridsearchcv to find best hyperparameters
3) Tensorflow Keras LSTM with earlystop patience 3 and 76740 predictions when tested
