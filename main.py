import cv2
import numpy as np
import paho.mqtt.client as mqtt

# MQTT setup
broker = "91.121.93.94"
port = 1883
topic = "light"

client = mqtt.Client()
client.connect(broker, port, 60)

# OpenCV setup
cap = cv2.VideoCapture(0)


def mark_grids(frame, grid_size):
    height, width, _ = frame.shape
    for i in range(0, width, grid_size):
        for j in range(0, height, grid_size):
            cv2.rectangle(frame, (i, j), (i + grid_size, j + grid_size), (255, 0, 0), 2)
    return frame


def detect_person(frame):
    hog = cv2.HOGDescriptor()
    hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())
    boxes, weights = hog.detectMultiScale(frame, winStride=(8, 8))
    return boxes


while True:
    ret, frame = cap.read()
    if not ret:
        break

    grid_size = 100  # Adjust grid size as needed
    frame = mark_grids(frame, grid_size)

    boxes = detect_person(frame)
    person_detected = False
    for (x, y, w, h) in boxes:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        if (x // grid_size) % 2 == 0 and (y // grid_size) % 2 == 0:
            person_detected = True

    if person_detected:
        client.publish(topic, "ON")
    else:
        client.publish(topic, "OFF")

    cv2.imshow('Frame', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()