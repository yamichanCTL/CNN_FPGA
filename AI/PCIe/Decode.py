import cv2
import numpy as np
import argparse

# 通过PCIE接收FPGA发送的数据
def receive_data():
    # 使用PCIE驱动程序接收数据，将数据存储到data变量中
    data = [0, 1, 2, 3]  # 这里使用了一个虚拟的data变量，实际应使用PCIE驱动程序接收数据
    return data

# 解析图像数据
def parse_image_data(data):
    # 将数据转换为NumPy数组
    img_data = np.array(data, dtype=np.uint8)
    # 将数据重塑为图像矩阵
    img = cv2.imdecode(img_data, cv2.IMREAD_COLOR)
    return img

# 解析视频数据
def parse_video_data(data):
    # 将数据转换为NumPy数组
    vid_data = np.array(data, dtype=np.uint8)
    # 将数据重塑为视频帧序列
    frames = []
    while len(vid_data) > 0:
        size = int.from_bytes(vid_data[:4], byteorder='little')
        frame_data = vid_data[4:size+4]
        frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
        frames.append(frame)
        vid_data = vid_data[size+4:]
    return frames

# 显示图像
def show_image(img):
    cv2.imshow("Image", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# 显示视频
def show_video(frames):
    for frame in frames:
        cv2.imshow("Video", frame)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            break
    cv2.destroyAllWindows()

if __name__ == '__main__':
    # 解析命令行参数
    parser = argparse.ArgumentParser()
    parser.add_argument('type', choices=['image', 'video'], default='image', help='数据类型（图像或视频）')
    args = parser.parse_args()

    # 接收数据并解析
    data = receive_data()
    if args.type == 'image':
        img = parse_image_data(data)
        show_image(img)
    elif args.type == 'video':
        frames = parse_video_data(data)
        show_video(frames)
