import socket
import threading
import time
import cv2
import numpy as np
import torch
from ultralytics import YOLO

model = YOLO('./model/best1.pt')

# Open the video file
video_path = "./pic/daySequence1.mp4"
cap = cv2.VideoCapture(video_path)

while True:
# Read a frame from the video
    success, frame = cap.read()

    # Run YOLOv8 inference on the frame
    results = model(frame)

    # Visualize the results on the frame
    annotated_frame = results[0].plot()
    # Display the annotated frame
    cv2.imshow("YOLOv8 Inference", annotated_frame)

    # Break the loop if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break