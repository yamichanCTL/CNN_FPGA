import socket
from socket import gethostname
import sys

Server_IP = ('127.0.0.1', 8080)


def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(Server_IP)

    # 包头标志
    arrBuf = bytearray(b'\xff\xaa\xff\xaa')

    # 以二进制方式读取图片
    picData = open('2022-08-19-15-28-37_0.png', 'rb')
    picBytes = picData.read()

    # 图片大小
    picSize = len(picBytes)

    # 数据体长度 = guid大小(固定) + 图片大小
    datalen = 64 + picSize
    print("datalen:"+str(datalen))

    # 组合数据包
    arrBuf += bytearray(datalen.to_bytes(4, byteorder='little'))
    # a = 1
    # print(a.to_bytes(4, byteorder='big'))
    print(arrBuf)

    guid = 23458283482894382928948
    arrBuf += bytearray(guid.to_bytes(64, byteorder='little'))
    print(guid.to_bytes(64, byteorder='little'))

    arrBuf += picBytes

    sock.sendall(arrBuf)
    sock.close()


if __name__ == '__main__':
    main()