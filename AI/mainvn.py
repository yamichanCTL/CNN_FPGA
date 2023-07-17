import socket
import threading
import time
import cv2
import numpy as np
import torch
from ultralytics import YOLO

pt_path = './model/V8.pt'
pt_path2 = './model/yolov8n.pt'
model = YOLO(pt_path)
# model = YOLO('G:/project/AI/ultralytics-main/runs/detect/test7/weights/best.pt')

cap = cv2.VideoCapture(0)  # Read a frame from the video
cap.set(3, 1920)
cap.set(4, 1080)

# Open the video file
video_path = "./pic/daySequence1.mp4"
cap2 = cv2.VideoCapture(video_path)

prev_time = time.time()

while True:

    ret, frame = cap.read()

    # Run YOLOv8 inference on the frame
    # results = model(frame)
    results = model.predict(frame,  imgsz=640, conf=0.4)# 320ok
    # Visualize the results on the frame
    annotated_frame = results[0].plot()

    # 对比度
    # adjusted_image = cv2.convertScaleAbs(frame, alpha=1.8, beta=0)

    curr_time = time.time()
    fps = int(1.0 / (curr_time - prev_time))
    prev_time = curr_time
    # Display the annotated frame
    cv2.namedWindow('detect_img', cv2.WINDOW_NORMAL)
    cv2.putText(annotated_frame, 'FPS:' + str(fps),  (50, 50),
                cv2.FONT_HERSHEY_SIMPLEX, 0.75, (36, 255, 12), 2)
    # cv2.putText(annotated_frame, 'rx_FPS:' + str(rx_fps),  (50, 80),
    #             cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
    cv2.imshow("detect_img", annotated_frame)

    time0 = time.time()
    # Break the loop if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()