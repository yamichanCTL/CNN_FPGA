from socket import *

host_name = gethostname()  # 10.169.0.83
prot_num = 9999

clientsocket = socket(AF_INET,SOCK_STREAM)
clientsocket.connect((host_name,prot_num))

message = input("input message:")
clientsocket.send(message.encode())

uppermessage = clientsocket.recv(1024).decode()
print("recieve message:" + uppermessage)

clientsocket.close()