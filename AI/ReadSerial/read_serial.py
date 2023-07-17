# -*- coding:utf-8 -*-
import serial
import time

# 串口配置
def serialConfig(port, buat):
    ser = serial.Serial(port, buat)
    ser.flushInput()
    ser.flushOutput()
    if ser.isOpen() is False:
        ser.open()
        return True, ser
    return True, ser

if __name__ == "__main__":
    isOpen, Ser = serialConfig('COM5', 115200)

    if isOpen is True:
        try:
            while True:
                size = Ser.inWaiting()  # 获得缓冲区字符
                #print(size)
                if size != 0:
                    response = Ser.read(size)  # 读取内容并显示
                    print(response)  # 将字节数据转换为字符串并打印
                    Ser.write(bytes(response))
                    Ser.flushOutput()
                    Ser.flushInput()  # 清空接收缓存区
                    time.sleep(0.2)  # 软件延时
        except KeyboardInterrupt:
            Ser.close()
    else:
        print("port false")


# import cv2   #版本为4.5.2
# import numpy as np
#
# cap0 = cv2.VideoCapture(1+ cv2.CAP_DSHOW)  # 视频流
# #cap0.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc('M', 'J', 'P', 'G'))  #读取视频格式
# # 设置分辨率
# cap0.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
# cap0.set(cv2.CAP_PROP_FRAME_HEIGHT, 1024)
# while(cap0.isOpened()):
#     ret,frame=cap0.read()
#     if ret==True:
#         cv2.imshow("frame", frame)
#     pass
#     if cv2.waitKey(1000)&0xFF==ord("q"):
#         break
#     pass
# pass
# cap0.release()
# cv2.destroyAllWindows()
