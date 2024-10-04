import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.preprocessing.image import ImageDataGenerator

import cv2
import numpy as np

def fire_detection():
    lower_bound = np.array([18, 50, 50])
    upper_bound = np.array([35, 255, 255])

    cap = cv2.VideoCapture(0)

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        mask = cv2.inRange(hsv, lower_bound, upper_bound)

        contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > 500:
                x, y, w, h = cv2.boundingRect(contour)
                cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 255), 2)
                cv2.putText(frame, 'Fire Detected', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)
            '''else:
                x, y, w, h = cv2.boundingRect(contour)
                cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
                cv2.putText(frame, 'NO Fire Detected', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)
        '''
        # Display the frame with detection
        cv2.imshow('Fire Detection', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

fire_detection()
'''
def build_and_train_model():

  model = Sequential([
      Conv2D(32, (3, 3), activation='relu', input_shape=(64, 64, 3)),
      MaxPooling2D(pool_size=(2, 2)),
      Conv2D(64, (3, 3), activation='relu'),
      MaxPooling2D(pool_size=(2, 2)),
      Flatten(),
      Dense(128, activation='relu'),
      Dense(1, activation='sigmoid')
  ])

  model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

  !mkdir /content/data
  !mkdir /content/data/fire
  !mkdir /content/data/no_fire



  train_datagen = ImageDataGenerator(
      rescale=1./255,
      shear_range=0.2,
      zoom_range=0.2,
      horizontal_flip=True
  )

  training_set = train_datagen.flow_from_directory(
      '/content/data',
      target_size=(64, 64),
      batch_size=32,
      class_mode='binary'
  )

  model.fit(training_set, epochs=10000)
  model.save('fire_detection_model.h5')
'''
def fire_detection():

  model = tf.keras.models.load_model('fire_detection_model.h5')

  cap = cv2.VideoCapture(0)
  while True:
      ret, frame = cap.read()
      if not ret:
          break

      img = cv2.resize(frame, (64, 64))
      img = np.expand_dims(img, axis=0)
      img = img / 255.0

      prediction = model.predict(img)

      if prediction[0][0] > 0.5:
          label = 'Fire Detected'
          color = (0, 0, 255)
      else:
          label = 'No Fire'
          color = (0, 255, 0)

      cv2.putText(frame, label, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)
      cv2.imshow('Fire Detection', frame)

      if cv2.waitKey(1) & 0xFF == ord('q'):
          break

  cap.release()
  cv2.destroyAllWindows()

build_and_train_model()
fire_detection()