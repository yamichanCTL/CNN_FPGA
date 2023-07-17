from socket import *

# host_name = "192.168.77.134"  # 10.169.0.83
host_name = gethostname()  # 10.169.0.83
prot_num = 9999

serversocket = socket(AF_INET,SOCK_STREAM)
serversocket.bind((host_name,prot_num))

serversocket.listen(2)
print("ready to recieve")

connectionSocket, address = serversocket.accept()
print(connectionSocket,address)
while True:
    message = connectionSocket.recv(1024).decode()
    print("recieve message is:" + message)
    if not message:
        break
    modifiedmessage = message.upper().encode()
    connectionSocket.send(modifiedmessage)
connectionSocket.close()
serversocket.close()