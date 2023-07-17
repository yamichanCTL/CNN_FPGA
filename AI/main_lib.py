import socket
import threading
import time
import cv2
import numpy as np
import torch
from ultralytics import YOLO
# 视频帧参数
pic_width = 1920
pic_height = 1080
begin_flag = b'Framebegin:'  # 一张图像起始标志
end_flag = b'Frameovers:'  # 一张图片结束标志
package_len = 4096  # 一帧数据长度
r_fps = 0

# yolo_path = r'G:/project/AI/yolov5_modify_smalltarget-master'
# pt_path = r'G:/project/AI/yolov5_modify_smalltarget-master/runs/train/day/weights/best.pt'
yolo_path = r'G:/college/machine learning/yolov5-6.1'
pt_path = r'./model/V8.pt'
# pt_path = r'./model/best1.pt'
img_path = r'./pic/daySequence1--00102.jpg'
output_path = '../pic/bus0.jpg'
size = 640
r_img = cv2.imread(img_path)
print(len(r_img))
flag = False
# 初始化模型
model = torch.hub.load(yolo_path,
                       'custom',
                       path=pt_path,
                       source='local',
                       force_reload=True)  # 加载模型
model.conf = 0.3  # NMS confidence threshold
model.iou = 0.4  # NMS IoU threshold
model.cuda()  # GPU
model.eval()

# camera
cap = cv2.VideoCapture(0)  # 名为'003.mp4'的文件
cap.set(3, 1920)
cap.set(4, 1080)

# Open the video file
video_path = "./pic/daySequence1.mp4"
cap2 = cv2.VideoCapture(video_path)

def udp_recv():
    global r_img
    global flag
    global r_fps
    # 网络参数
    host = ('10.169.250.196', 8081)
    client_list = []  # 保存 客户端addr 的列表
    server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server.bind(host)

    try:
        while True:
            data, addr = server.recvfrom(package_len)
            if not (addr in client_list):  # 将客户端添加进列表
                client_list.append(addr)
            if data:  # 判断data不为空
                if data == begin_flag:  # 如果图像数据包来了
                    time0 = time.time()
                    # flag = False
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
                    flag = True
                    time1 = time.time()
                    r_fps = int(1 / (time1 - time0))
                    # r_img = r_img.reshape(pic_height, pic_width, 3)  # 会报错
                    # cv2.imshow("origin",r_img)
                    # detect(r_img)
                    if cv2.waitKey(1) & 0xFF == ord('q'):
                        break
                else:
                    print("receive break")
    finally:
        cv2.destroyAllWindows()

def detect_udp(img):
    global r_img
    convert_img = cv2.cvtColor(r_img, cv2.COLOR_BGR2RGB)#
    time0 = time.perf_counter()
    results = model(convert_img)
    boxs = results.pandas().xyxy[0].values
    time1 = time.perf_counter()
    FPS = int(1 / (time1 - time0))
    detect_show(r_img, boxs, FPS)

def detect_hdmi():
    # source
    ret, r_img = cap2.read()
    convert_img = cv2.cvtColor(r_img, cv2.COLOR_BGR2RGB)#
    time0 = time.perf_counter()
    results = model(convert_img)
    boxs = results.pandas().xyxy[0].values
    print(boxs)
    time1 = time.perf_counter()
    FPS = int(1 / (time1 - time0))
    detect_show(r_img, boxs, FPS)

def detect_show(org_img, boxs,FPS):
    img = org_img.copy()
    for box in boxs:
        # rectangle画框，参数表示依次为：(图片，长方形框左上角坐标, 长方形框右下角坐标， 字体颜色，字体粗细)
        cv2.rectangle(img, (int(box[0]), int(box[1])), (int(box[2]), int(box[3])), (0, 0, 255), 2)  ###?
        # putText各参数依次是：图片，添加的文字(标签+深度-单位m)，左上角坐标，字体，字体大小，颜色，字体粗细
        cv2.putText(img, 'confidence:' + str(round(box[4], 2)), (int(box[0]), int(box[1]-10)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
        cv2.putText(img, 'class:' + box[6], (int(box[0]), int(box[1]-30)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
        cv2.putText(img, 'Inference_FPS:' + str(FPS),  (50, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
        # cv2.putText(img, 'Ethernet_FPS:' + str(r_fps), (50, 100),
        #             cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
    cv2.namedWindow('detect_img', cv2.WINDOW_NORMAL)
    cv2.imshow('detect_img', img)
    cv2.waitKey(1)

# def test():
#     global r_img
#     print(len(r_img))


if __name__ == "__main__":
    t0 = threading.Thread(target=udp_recv)
    t0.start()
    # t1 = threading.Thread(target=detect(r_img))
    # t1.start()
    while True:
        detect_hdmi()
    # while True:
    #     if flag == True:
    #         flag = False
    #         detect(r_img)