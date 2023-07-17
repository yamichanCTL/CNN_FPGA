import serial
import time
import serial.tools.list_ports
import numpy as np
import cv2

time0=time.perf_counter()

port_list = list(serial.tools.list_ports.comports())
image=[]
a = [1, 2, 3]




port_list_0 = list(port_list[0])  # 第一个串口及具体信息
port_serial = port_list_0[0]  # 串口号
ser = serial.Serial(port_serial, 115200, timeout=0.5)
ser.bytesize = 8  # 8位字符
ser.stopbits = 1  # 1位停止位
print("Waiting data from:" + ser.name)

while (1):
    # head = ser.readline() # 是读一行，以\n结束，要是没有\n就一直读，阻塞。
    # 读取数据头帧，以\n换行结束
    data = ser.read(4)
    image = np.append(image,np.asarray(bytearray(data), dtype="uint8"))
    print(len(image))
    if len(image)==1080*1920*3:
        image = image.reshape((1080, 1920, 3))
        cv2.imshow("result", image)
        cv2.waitKey(30000)
