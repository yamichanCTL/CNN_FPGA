import sys
import onnx
import onnx_extract
import onnxruntime as ort
import cv2
import numpy as np
import torch
from CSM import CSM
from FP16hex import *

# parameters
CLASSES = ['stops', 'b', 'c', 'd','e']
img_size = (640, 640)
onnx_path_1 = r'G:\project\IC\CICC2023\CNN_FPGA\AI\model\batch1_640_640_part1.onnx'
onnx_path_2 = r'G:\project\IC\CICC2023\CNN_FPGA\AI\model\batch1_640_640_part2.onnx'
img_path = r'G:\project\IC\CICC2023\CNN_FPGA\AI\pic\daySequence1--00102.jpg'
output_path = './pic/stop6.jpg'
conf_thres = 0.5
iou_thres = 0.5
weight_path = r'.\parameters\model.2.cv3.conv.weight.npy'
bias_path = r'.\parameters\model.2.cv3.conv.bias.npy'

# load model
class Yolov5ONNX(object):
    def __init__(self, onnx_path_1, onnx_path_2):
        """检查onnx模型并初始化onnx"""
        onnx_model_1 = onnx.load(onnx_path_1)
        onnx_model_2 = onnx.load(onnx_path_2)
        try:
            onnx.checker.check_model(onnx_model_1)
            onnx.checker.check_model(onnx_model_2)
        except Exception:
            print("Model incorrect")
        else:
            print("Model correct")

        options = ort.SessionOptions()
        options.enable_profiling = True
        # 推理内核切换
        # self.onnx_session = ort.InferenceSession(onnx_path, sess_options=options,
        #                                          providers=['CUDAExecutionProvider', 'CPUExecutionProvider'])
        self.onnx_session_1 = ort.InferenceSession(onnx_path_1)
        self.onnx_session_2 = ort.InferenceSession(onnx_path_2)
        self.input_name_1 = self.get_input_name(1)  # ['images']
        self.output_name_1 = self.get_output_name(1)  # ['output0']
        self.input_name_2 = self.get_input_name(2)  # ['images']
        self.output_name_2 = self.get_output_name(2)  # ['output0']

    def get_input_name(self, a):
        """获取输入节点名称"""
        input_name = []
        if a==1:
            for node in self.onnx_session_1.get_inputs():
                input_name.append(node.name)
        elif a==2:
            for node in self.onnx_session_2.get_inputs():
                input_name.append(node.name)
        return input_name

    def get_output_name(self, a):
        """获取输出节点名称"""
        output_name = []
        if a==1:
            for node in self.onnx_session_1.get_outputs():
                output_name.append(node.name)
        elif a==2:
            for node in self.onnx_session_2.get_outputs():
                output_name.append(node.name)
        return output_name

    def get_input_feed(self, image_numpy ,a):
        """获取输入numpy"""
        input_feed = {}
        if a==1:
            for name in self.input_name_1:
                input_feed[name] = image_numpy
        elif a==2:
            for name in self.input_name_2:
                input_feed[name] = image_numpy
        return input_feed

    def inference(self, img_path):
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
        # img尺寸(1, 3, 640, 640)
        input_feed_1 = self.get_input_feed(img,1)  # dict:{ input_name: input_value }
        temp = self.onnx_session_1.run(None, input_feed_1)[0]  # <class 'numpy.ndarray'>(1, 25200, 9)
        print(temp.dtype)
        float16_FP16(temp,"./parameters/test.txt")

        ## test
        net = CSM().to('cuda' if torch.cuda.is_available() else 'cpu')
        net.conv.weight.data =torch.from_numpy(np.load(weight_path).astype(np.float32))
        net.conv.bias.data = torch.from_numpy(np.load(bias_path).astype(np.float32))
        mul_out = net.forward(torch.from_numpy(temp))
        ## part2
        input_feed_2 = self.get_input_feed(mul_out.detach().numpy(),2)  # dict:{ input_name: input_value }
        pred = self.onnx_session_2.run(None, input_feed_2)[0]  # <class 'numpy.ndarray'>(1, 25200, 9)
        return pred, or_img

# 过滤掉无用的框
def filter_box(org_box, conf_thres, iou_thres):
    # 1.删除维度1
    org_box = np.squeeze(org_box)  # 删除数组形状中单维度条目(shape中为1的维度) shape(25200,10)
    # print('删除维度1shape:')
    # print(org_box.shape)

    # 2.删除置信度小于conf_thres的BOX
    # […,4]：代表了取最里边一层的所有第4号元素，…代表了对:,:,:,等所有的的省略。此处生成：25200个第四号元素组成的数组
    conf = org_box[..., 4] > conf_thres  # 0 1 2 3 4 4是置信度，只要置信度 > conf_thres 的
    box = org_box[conf == True]  # 根据objectness score生成(n, 10)，只留下符合要求的框
    print('box:符合要求的框')
    print(box.shape)
    print(box)

    # 3.通过argmax获取置信度最大的类别index
    cls_cinf = box[..., 5:]  # 左闭右开，就只剩下了每个grid cell中各类别的概率
    cls = []  # 对应class的下标
    for i in range(len(cls_cinf)):
        cls.append(int(np.argmax(cls_cinf[i])))  # 剩下的objecctness score比较大的grid cell，分别对应的预测类别列表
    all_cls = list(set(cls))  # 去重，找出图中都有哪些类别set()

    # 4.分别对每个类别进行过滤
    # 4.1.将第6列元素替换为类别下标
    output = []
    for i in range(len(all_cls)):
        curr_cls = all_cls[i] #
        curr_cls_box = []
        curr_out_box = []
        for j in range(len(cls)):
            if cls[j] == curr_cls:
                box[j][5] = curr_cls
                curr_cls_box.append(box[j][:6])  # 左闭右开，0 1 2 3 4 5
        curr_cls_box = np.array(curr_cls_box)  # 0 1 2 3 4 5 分别是 x y w h score class
        # curr_cls_box_old = np.copy(curr_cls_box)
        # 4.2.xywh2xyxy 坐标转换
        curr_cls_box = xywh2xyxy(curr_cls_box)  # 0 1 2 3 4 5 分别是 x1 y1 x2 y2 score class
        # 4.3.经过非极大抑制后输出的BOX下标
        curr_out_box = nms(curr_cls_box, iou_thres)  # 获得nms后，剩下的类别在curr_cls_box中的下标
        # 4.4.利用下标取出非极大抑制后的BOX
        for k in curr_out_box:
            output.append(curr_cls_box[k])
    output = np.array(output)
    return output

# dets:  array [x,6] 6个值分别为x1,y1,x2,y2,score,class
# thresh: 阈值
def nms(dets, thresh):
    # dets:x1 y1 x2 y2 score class
    # x[:,n]就是取所有集合的第n个数据
    x1 = dets[:, 0]
    y1 = dets[:, 1]
    x2 = dets[:, 2]
    y2 = dets[:, 3]
    # -------------------------------------------------------
    #   计算框的面积
    #	置信度从大到小排序
    # -------------------------------------------------------
    areas = (y2 - y1 + 1) * (x2 - x1 + 1)
    scores = dets[:, 4]
    # print(scores)
    keep = []
    index = scores.argsort()[::-1]  # np.argsort()对某维度从小到大排序
    # [::-1] 从最后一个元素到第一个元素复制一遍。倒序从而从大到小排序

    while index.size > 0:
        i = index[0]
        keep.append(i)
        # -------------------------------------------------------
        #   计算相交面积
        #	1.相交
        #	2.不相交
        # -------------------------------------------------------
        x11 = np.maximum(x1[i], x1[index[1:]])
        y11 = np.maximum(y1[i], y1[index[1:]])
        x22 = np.minimum(x2[i], x2[index[1:]])
        y22 = np.minimum(y2[i], y2[index[1:]])

        w = np.maximum(0, x22 - x11 + 1)
        h = np.maximum(0, y22 - y11 + 1)

        overlaps = w * h
        # -------------------------------------------------------
        #   计算该框与其它框的IOU，去除掉重复的框，即IOU值大的框
        #	IOU小于thresh的框保留下来
        # -------------------------------------------------------
        ious = overlaps / (areas[i] + areas[index[1:]] - overlaps)
        idx = np.where(ious <= thresh)[0]
        index = index[idx + 1]
    return keep

# 坐标转换 [x, y, w, h] to [x1, y1, x2, y2]
def xywh2xyxy(x):
    y = np.copy(x)
    y[:, 0] = x[:, 0] - x[:, 2] / 2
    y[:, 1] = x[:, 1] - x[:, 3] / 2
    y[:, 2] = x[:, 0] + x[:, 2] / 2
    y[:, 3] = x[:, 1] + x[:, 3] / 2
    return y

def draw(image, box_data):
    # 取整，方便画框
    boxes = box_data[..., :4].astype(np.int32)  # x1 x2 y1 y2
    scores = box_data[..., 4]
    classes = box_data[..., 5].astype(np.int32)
    for box, score, cl in zip(boxes, scores, classes):
        top, left, right, bottom = box
        print('class: {}, score: {}'.format(CLASSES[cl], score))
        print('box coordinate left,top,right,down: [{}, {}, {}, {}]'.format(top, left, right, bottom))

        cv2.rectangle(image, (top, left), (right, bottom), (255, 0, 0), 2)
        cv2.putText(image, '{0} {1:.2f}'.format(CLASSES[cl], score),
                    (top, left),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.6, (0, 0, 255), 2)
    return image

if __name__ == "__main__":
    model = Yolov5ONNX(onnx_path_1, onnx_path_2)
    output, or_img = model.inference(img_path)
    # print(output)
    # print('pred: 位置[0, 0, :]的数组')
    # print(output.shape) # 输出数据是 (1, 25200, 4+1+class)：4+1+class 是检测框的坐标、大小 和 分数。
    # print(output[0, 0, :])

    # # result extract
    # outbox = filter_box(output, conf_thres, iou_thres)  # 最终剩下的Anchors：0 1 2 3 4 5 分别是 x1 y1 x2 y2 score class
    # print('outbox( x1 y1 x2 y2 score class):')
    # print(outbox)
    # if len(outbox) == 0:
    #     print('没有发现物体')
    #     sys.exit(0)
    #
    # # show and save
    # or_img = draw(or_img, outbox)
    # cv2.imwrite(output_path, or_img)
