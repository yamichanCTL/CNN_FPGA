import socketserver
from socket import gethostname
import cv2
import time
import numpy as np
import os
import sys
import time
import threading

ip_port = ('127.0.0.1', 8080)


class MyServer(socketserver.BaseRequestHandler):
    def handle(self):
        print("conn is :", self.request)  # conn
        print("addr is :", self.client_address)  # addr

        while True:
            try:
                self.str = self.request.recv(8)
                data = bytearray(self.str)
                headIndex = data.find(b'\xff\xaa\xff\xaa')
                print(headIndex)

                if headIndex == 0:
                    time0 = time.perf_counter()
                    allLen = int.from_bytes(data[headIndex + 4:headIndex + 8], byteorder='little')
                    print("len is ", allLen)

                    curSize = 0
                    allData = b''
                    while curSize < allLen:
                        data = self.request.recv(65536)
                        allData += data
                        curSize += len(data)

                    print("recv data len is ", len(allData))
                    # 接收到的数据，前64字节是guid，后面的是图片数据
                    arrGuid = allData[0:64]
                    # 去除guid末尾的0
                    tail = arrGuid.find(b'\x00')
                    arrGuid = arrGuid[0:tail]
                    strGuid = str(int.from_bytes(arrGuid, byteorder='little'))  # for test

                    print("-------------request guid is ", strGuid)
                    imgData = allData[64:]
                    strImgFile = "TESTbmp.jpg"
                    print("img file name is ", strImgFile)
                    time1 = time.perf_counter()

                    # img = np.asarray(bytearray(imgData), dtype="uint8")
                    # cv2.imwrite("test.png",img)
                    # 将图片数据保存到本地文件
                    with open(strImgFile, 'wb') as f:
                        f.write(imgData)
                        f.close()

                        print(time1-time0)
                    # recv_img = cv2.imread(strImgFile)
                    # cv2.imshow("title", recv_img)
                    # cv2.waitKey(10000)
                    break

            except Exception as e:
                print(e)
                break


if __name__ == "__main__":
    s = socketserver.ThreadingTCPServer(ip_port, MyServer)
    print("start listen")
    s.serve_forever()