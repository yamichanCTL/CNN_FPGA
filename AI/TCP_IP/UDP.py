import cv2
import numpy as np
import socket

host = ('169.254.25.224', 8081)
server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.bind(host)
while True:
    data, addr = server.recvfrom(20)
    print(data)
    print(addr)