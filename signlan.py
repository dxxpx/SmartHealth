import cv2
import mediapipe as mp
import time


time.sleep(2.0)


mp_draw = mp.solutions.drawing_utils
mp_hand = mp.solutions.hands

tipIds = [4, 8, 12, 16, 20]

video = cv2.VideoCapture(0)

with mp_hand.Hands(min_detection_confidence=0.5,
                   min_tracking_confidence=0.5) as hands:
    while True:
        ret, image = video.read()
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
        results = hands.process(image)
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        lmList = []
        if results.multi_hand_landmarks:
            for hand_landmark in results.multi_hand_landmarks:
                myHands = results.multi_hand_landmarks[0]
                for id, lm in enumerate(myHands.landmark):
                    h, w, c = image.shape
                    cx, cy = int(lm.x * w), int(lm.y * h)
                    lmList.append([id, cx, cy])
                mp_draw.draw_landmarks(image, hand_landmark, mp_hand.HAND_CONNECTIONS)
        fingers = []
        if len(lmList) != 0:
            if lmList[tipIds[0]][1] > lmList[tipIds[0] - 1][1]:
                fingers.append(1)
            else:
                fingers.append(0)
            for id in range(1, 5):
                if lmList[tipIds[id]][2] < lmList[tipIds[id] - 2][2]:
                    fingers.append(1)
                else:
                    fingers.append(0)
            total = fingers.count(1)
            '''cnt.led(total)'''
            if total == 0:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "ELECTRIC  ", (45, 250), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "EQUIPMENT  ", (45, 300), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "FAULT", (100, 350), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
            elif total == 1:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "AIR QUALITY", (45, 300), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "AND AMBIENCE", (100, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
            elif total == 2:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "SECURITY ", (45, 300), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "ISSUES", (100, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
            elif total == 3:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "PLACE ", (45, 300), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "IS UNCLEAN", (100, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
            elif total == 4:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "WATER PROBLEM", (45, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "", (100, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
            elif total == 5:
                '''cv2.rectangle(image, (20, 300), (270, 425), (0, 255, 0), cv2.FILLED)'''
                cv2.putText(image, "EMERGENCY HELP", (45, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
                cv2.putText(image, "", (100, 375), cv2.FONT_HERSHEY_SIMPLEX,
                            2, (128, 255, 0), 5)
        cv2.imshow("Frame", image)
        k = cv2.waitKey(1)
        if k == ord('q'):
            break
video.release()
cv2.destroyAllWindows()