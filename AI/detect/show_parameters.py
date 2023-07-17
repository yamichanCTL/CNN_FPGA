import torch
# yolo_path = r'G:/college/machine learning/yolov5-6.1'
# yolo_lite = r'G:/project/IC/CICC2023/yolov5-Lite-master'
# pt_path = r'../model/jiaotongv5n.pt'
onnx_path1 = r'../model/n_320_320.onnx'
onnx_path2 = r'../model/v5lite-e-sim-320.onnx'
# img_path = r'../pic/daySequence1--00102.jpg'
# output_path = '../pic/bus0.jpg'
# size = 640
# # model = models.alexnet()
#
# model = torch.hub.load(yolo_lite,
#                         'custom',
#                         path=pt_path2,
#                         source='local',
#                         force_reload=True)  # 加载模型
# model.eval()
# total_num = sum(p.numel() for p in model.parameters())
# print('Total parameters:',total_num)

import onnx
import numpy as np

# 加载ONNX模型
# model_path = 'your_model.onnx'
model = onnx.load(onnx_path1)

# 获取模型的图
graph = model.graph

# 计算总参数数量
total_params = 0
for initializer in graph.initializer:
    shape = []
    for dim in initializer.dims:
        shape.append(dim)
    param_size = np.prod(shape)
    total_params += param_size
print('origin yolov5n:')
print("Total parameters: ", total_params)


# 加载ONNX模型
# model_path = 'your_model.onnx'
model = onnx.load(onnx_path2)

# 获取模型的图
graph = model.graph

# 计算总参数数量
total_params = 0
for initializer in graph.initializer:
    shape = []
    for dim in initializer.dims:
        shape.append(dim)
    param_size = np.prod(shape)
    total_params += param_size
print('modifed yolov5:')
print("Total parameters: ", total_params)
