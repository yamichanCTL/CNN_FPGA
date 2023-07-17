# 客户端和服务端相互发送
import socket

server_sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# v  192.168.77.134
ip_port = ('192.168.77.134', 9999)# 10.169.0.83
server_sk.bind(ip_port)
server_sk.listen(128)
new_sk, addr = server_sk.accept()
# 先接受客户端发送的数据
while True:
    ret = new_sk.recv(1024).decode('utf-8')
    print('客户端:', ret)
    if ret == 'bye':
        break
    # 向客户端发送数据
    s = input('我:')
    new_sk.send(s.encode('utf-8'))
    if s == 'bye':
        break
new_sk.close()
server_sk.close()
