import cv2   #版本为4.5.2
import numpy as np

cap0 = cv2.VideoCapture(1+ cv2.CAP_DSHOW)  # 视频流
#cap0.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc('M', 'J', 'P', 'G'))  #读取视频格式
# 设置分辨率
cap0.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
cap0.set(cv2.CAP_PROP_FRAME_HEIGHT, 1024)
while(cap0.isOpened()):
    ret,frame=cap0.read()
    if ret==True:
        cv2.imshow("frame", frame)
    pass
    if cv2.waitKey(1000)&0xFF==ord("q"):
        break
    pass
pass
cap0.release()
cv2.destroyAllWindows()
