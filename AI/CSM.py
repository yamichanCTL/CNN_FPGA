# conv + sigmoid + mul

import torch
import torch.nn as nn
import cv2
import numpy as np

# parameters
img_size = (160, 160)
img_path = r'.\pic\daySequence1--00102.jpg'
output_path = './pic/stop3.jpg'
weight_path = r'.\parameters\model.2.cv3.conv.weight.npy'
bias_path = r'.\parameters\model.2.cv3.conv.bias.npy'


def inference(img_path):
    """ 1.cv2读取图像并resize
    2.图像转BGR2RGB和HWC2CHW(因为yolov5的onnx模型输入为 RGB：1 × 3 × 640 × 640)
    3.图像归一化
    4.图像增加维度
    5.onnx_session 推理 """
    img = cv2.imread(img_path)
    or_img = cv2.resize(img, img_size)  # resize后的原图 (640, 640, 3)
    img = or_img[:, :, ::-1].transpose(2, 0, 1)  # BGR2RGB和HWC2CHW
    img = img.astype(dtype=np.float32)  # onnx模型的类型是type: float32[ , , , ]
    img /= 255.0
    img = np.expand_dims(img, axis=0)  # [3, 640, 640]扩展为[1, 3, 640, 640]
    return img

# load model
class CSM(nn.Module):
    def __init__(self):
        super(CSM, self).__init__()
        self.conv = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        conv_out = self.conv(x)
        sigmoid_out = self.sigmoid(conv_out)
        mul_out = conv_out*sigmoid_out
        return mul_out

if __name__ == "__main__":
    img = inference(img_path)
    img = torch.from_numpy(img)
    print(img.shape)

    # model
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    net = CSM().to(device)
    # 权重偏差赋值
    weight = torch.from_numpy(np.load(weight_path).astype(np.float32))
    bias = torch.from_numpy(np.load(bias_path).astype(np.float32))
    #bias = torch.from_numpy(bias)

    net.conv.weight.data = weight
    net.conv.bias.data = bias

    mul_out = net.forward(img)
    print(mul_out.shape)
