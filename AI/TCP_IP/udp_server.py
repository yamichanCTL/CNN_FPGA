import socket
import threading
import time
import pyautogui
import cv2
import numpy as np

# 收到图像的大小
pic_width = 1920
pic_height = 1080
begin_flag = b'Framebegin:'  # 一张图像起始标志
end_flag = b'Frameovers:'  # 一张图片结束标志
package_len = 2048  # 一帧数据长度
host = ('127.0.0.1', 8081)
client_list = []  # 保存 客户端addr 的列表

# # 向所有客户端发送数据
# def send_msg():
#     while True:
#         for client in client_list:
#             server.sendto("Server Msg!".encode(), client)
#         time.sleep(2)

# 接收客户端的数据
def recv_data():
    server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server.bind(host)
    img_bytes = b''  # 保存一张图像
    while True:
        data, addr = server.recvfrom(package_len)
        if not (addr in client_list):  # 将客户端添加进列表
            client_list.append(addr)
        if data:  # 判断data不为空
            if data == begin_flag:  # 如果图像数据包来了
                time0 = time.time()
                img_bytes = b''
                while True:  # 开启一个循环接受数据
                    data, addr = server.recvfrom(package_len)
                    # 如果结束包来了  则说明一张图像数据完毕  udp 结束包是单独过来的 tcp 结束包会和最后一个图像数据包混在一起
                    if data == end_flag:
                        break  # 跳出接收这样图像的循环
                    img_bytes = img_bytes + data  # 如果不是结束包 则将数据添加到变量 继续循环
                # 显示图片
                np_data = np.frombuffer(img_bytes, dtype="uint8")
                r_img = cv2.imdecode(np_data, cv2.IMREAD_COLOR)
                # r_img = r_img.reshape(pic_height, pic_width, 3)  # 会报错

                # cv2.imwrite('udpphoto.jpg', r_img)
                # recv = cv2.imread('udpphoto.jpg')
                cv2.imshow("title", r_img)
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break
            else:
                print(data)
    cv2.destroyAllWindows()

# def store():


if __name__ == "__main__":
    t0 = threading.Thread(target=recv_data)
    t0.start()
    # t1 = threading.Thread(target=store)
    # t1.start()
    # t1 = threading.Thread(target=send_msg)
    # t1.start()