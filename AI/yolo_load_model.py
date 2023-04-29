import torch
import torch.nn as nn
import numpy as np
# from weight import *
from torchvision.transforms.functional import InterpolationMode, _interpolation_modes_from_int
from torchvision.transforms import Resize

b1 = torch.from_numpy(np.load(r'.\parameters\b1.npy', allow_pickle=True).astype(np.float32))
b2 = torch.from_numpy(np.load(r'.\parameters\b2.npy', allow_pickle=True).astype(np.float32))
b3 = torch.from_numpy(np.load(r'.\parameters\b3.npy', allow_pickle=True).astype(np.float32))
b4 = torch.from_numpy(np.load(r'.\parameters\b4.npy', allow_pickle=True).astype(np.float32))
b5 = torch.from_numpy(np.load(r'.\parameters\b5.npy', allow_pickle=True).astype(np.float32))
b6 = torch.from_numpy(np.load(r'.\parameters\b6.npy', allow_pickle=True).astype(np.float32))
class yolov5s(nn.Module):
    def __init__(self):
        super(yolov5s, self).__init__()
        self.maxpool = nn.MaxPool2d(5, 1, 2)
        self.Sigmoid = nn.Sigmoid()
        self.conv_0 = nn.Conv2d(in_channels=3,
                                 out_channels=32,
                                 kernel_size=6,
                                 stride=2,
                                 padding=2,
                                 bias=True)
        self.conv_3 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_6 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_9 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_12 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_16 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_20 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_23 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_26 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_29 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_32 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_36 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_39 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_43 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_47 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_50 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_53 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_56 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_59 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_63 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_66 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_70 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_73 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_77 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_81 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_84 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_87 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_90 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_93 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_97 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_101 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_104 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_111 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_114 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_120 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_123 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_126 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_129 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_133 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_136 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_142 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_145 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_148 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_151 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_155 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_158 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_162 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_165 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_168 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_171 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_175 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_178 = nn.Conv2d(1, 1, kernel_size=3, stride=2, padding=1)
        self.conv_182 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_185 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_188 = nn.Conv2d(1, 1, kernel_size=3, stride=1, padding=1)
        self.conv_191 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_195 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_198 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_233 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)
        self.conv_268 = nn.Conv2d(1, 1, kernel_size=1, stride=1, padding=0)

        # self.sigmoid = nn.Sigmoid()
        # self.bn = nn.BatchNorm2d(1)
        # self.relu = nn.ReLU6()

    def forward(self, x):
        x = self.conv_0(x)
        x = x * self.Sigmoid(x)
        x = self.conv_3(x)
        x = x * self.Sigmoid(x)
        # left
        x1 = self.conv_6(x)
        x1 = x1 * self.Sigmoid(x1)
        x11 = self.conv_9(x1)
        x11 = x11 * self.Sigmoid(x11)
        x11 = self.conv_12(x11)
        x11 = x11 * self.Sigmoid(x11)
        x1 = x1 + x11
        # right
        x2 = self.conv_16(x)
        x2 = x2 * self.Sigmoid(x2)
        # concat
        x = torch.cat((x1,x2),1)

        x = self.conv_20(x)
        x = x * self.Sigmoid(x)
        x = self.conv_23(x)
        x = x * self.Sigmoid(x)
        # left
        x1 = self.conv_26(x)
        x1 = x1 * self.Sigmoid(x1)
        x12 = self.conv_29(x1)
        x12 = x12 * self.Sigmoid(x12)
        x12 = self.conv_32(x12)
        x12 = x12 * self.Sigmoid(x12)
        x1 = x1 + x12
        x12 = self.conv_36(x1)
        x12 = x12 * self.Sigmoid(x12)
        x12 = self.conv_39(x12)
        x12 = x12 * self.Sigmoid(x12)
        x1 = x1 + x12
        # right
        x2 = self.conv_43(x)
        x2 = x2 * self.Sigmoid(x2)
        # concat
        x = torch.cat((x1,x2),1)

        x = self.conv_47(x)
        x = x * self.Sigmoid(x)
        # right
        x2 = self.conv_50(x)
        x2 = x2 * self.Sigmoid(x2)
        # right left
        x21 = self.conv_53(x2)
        x21 = x21 * self.Sigmoid(x21)
        x212 = self.conv_56(x21)
        x212 = x212 * self.Sigmoid(x212)
        x212 = self.conv_59(x212)
        x212 = x212 * self.Sigmoid(x212)
        x21 = x21 + x212
        x212 = self.conv_63(x21)
        x212 = x212 * self.Sigmoid(x212)
        x212 = self.conv_66(x212)
        x212 = x212 * self.Sigmoid(x212)
        x21 = x21 + x212
        x212 = self.conv_70(x21)
        x212 = x212 * self.Sigmoid(x212)
        x212 = self.conv_73(x212)
        x212 = x212 * self.Sigmoid(x212)
        x21 = x21 + x212
        # right right
        x22 = self.conv_77(x2)
        x22 = x22 * self.Sigmoid(x22)
        # concat
        x2 = torch.cat((x21,x22),1)

        # right
        x2 = self.conv_81(x2)
        x2 = x2 * self.Sigmoid(x2)
        # right left
        x22 = self.conv_84(x2)
        x22 = x22 * self.Sigmoid(x22)
        x221 = self.conv_87(x22)
        x221 = x221 * self.Sigmoid(x221)
        x2212 = self.conv_90(x221)
        x2212 = x2212 * self.Sigmoid(x2212)
        x2212 = self.conv_93(x2212)
        x2212 = x2212 * self.Sigmoid(x2212)
        x221 = x221 + x2212
        x222 = self.conv_97(x22)
        x222 = x222 * self.Sigmoid(x222)
        # concat
        x22 = torch.cat((x221,x222),1)

        x22 = self.conv_101(x22)
        x22 = x22 * self.Sigmoid(x22)
        x22 = self.conv_104(x22)
        x22 = x22 * self.Sigmoid(x22)
        # maxpool
        x222 = self.maxpool(x22)
        x2222 = self.maxpool(x222)
        x22222 = self.maxpool(x2222)
        x22 = x22 + x222 + x2222+ x22222
        # concat
        x22 = torch.cat((x22,x222,x2222,x22222),1)

        x22 = self.conv_111(x22)
        x22 = x22 * self.Sigmoid(x22)
        x22 = self.conv_114(x22)
        x22 = x222 * self.Sigmoid(x22)
        '''    # resize             '''
        torch_resize = Resize([2 * x22.shape[2], 2 * x22.shape[3]], interpolation=InterpolationMode.NEAREST)  # 定义Resize类对象
        x221 = torch_resize(x22)
        # concat
        x21 = torch.cat((x2,x221),1)

        x211 = self.conv_120(x21)
        x211 = x211 * self.Sigmoid(x211)
        x211 = self.conv_123(x211)
        x211 = x211 * self.Sigmoid(x211)
        x211 = self.conv_126(x211)
        x211 = x211 * self.Sigmoid(x211)
        x212 = self.conv_129(x21)
        x212 = x212 * self.Sigmoid(x212)
        # concat
        x21 = torch.cat((x211,x212),1)

        x21 = self.conv_133(x21)
        x21 = x21 * self.Sigmoid(x21)
        x21 = self.conv_136(x21)
        x21 = x21 * self.Sigmoid(x21)
        # resize
        torch_resize = Resize([2 * x21.shape[2], 2 * x21.shape[3]], interpolation=InterpolationMode.NEAREST)  # 定义Resize类对象
        x211 = torch_resize(x21)
        # concat
        x1 = torch.cat((x,x211),1)

        x11 = self.conv_142(x1)
        x11 = x11 * self.Sigmoid(x11)
        x11 = self.conv_145(x11)
        x11 = x11 * self.Sigmoid(x11)
        x11 = self.conv_148(x11)
        x11 = x11 * self.Sigmoid(x11)
        x12 = self.conv_151(x1)
        x12 = x12 * self.Sigmoid(x12)
        #concat
        x1 = torch.cat((x11,x12),1)

        x1 = self.conv_155(x1)
        x1 = x1 * self.Sigmoid(x1)

        '''-----------------over1--------------------'''
        x11 = self.conv_198(x1)
        # reshape
        x11 = x11.reshape([1,3,10,80,80])
        # transpose
        x11 = x11.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        x12 = self.conv_158(x1)
        x12 = x12 * self.Sigmoid(x12)
        # concat
        x12 = torch.cat((x12,x21),1)

        x121 = self.conv_162(x12)
        x121 = x121 * self.Sigmoid(x121)
        x121 = self.conv_165(x121)
        x121 = x121 * self.Sigmoid(x121)
        x121 = self.conv_168(x121)
        x121 = x121 * self.Sigmoid(x121)
        x122 = self.conv_171(x12)
        x122 = x122 * self.Sigmoid(x122)
        #concat
        x12 = torch.cat((x121,x122),1)

        x12 = self.conv_175(x12)
        x12 = x12 * self.Sigmoid(x12)
        '''-----------------over2--------------------'''
        x121 = self.conv_233(x12)
        # reshape
        x121 = x121.reshape([1, 3, 10, 40, 40])
        # transpose
        x121 = x121.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        x122 = self.conv_178(x12)
        x122 = x122 * self.Sigmoid(x122)
        # concat
        x22 = torch.cat((x22,x122),1)

        x221 = self.conv_182(x22)
        x221 = x221 * self.Sigmoid(x221)
        x221 = self.conv_185(x221)
        x221 = x221 * self.Sigmoid(x221)
        x221 = self.conv_188(x221)
        x221 = x221 * self.Sigmoid(x221)
        x222 = self.conv_191(x22)
        x222 = x222 * self.Sigmoid(x222)
        # concat
        x22 = torch.cat((x221,x222),1)

        x22 = self.conv_195(x22)
        x22 = x22 * self.Sigmoid(x22)
        '''-----------------over3--------------------'''
        x22 = self.conv_268(x22)
        # reshape
        x22 = x22.reshape([1, 3, 10, 20, 20])
        # transpose
        x22 = x22.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        '''--------------------1---------------------'''
        x11 = self.Sigmoid(x11)
        # slice
        x111 = x11[:,:,:,:,2:4]
        x111 = x111 * 2
        x111 = x111 - 0.5
        x111 = x111 + b1
        x111 = x111 * 8
        # slice
        x112 = x11[:,:,:,:,2:4]
        x112 = x112 * 2
        x112 = pow(x112,2)
        x112 = x112 * b2
        # slice
        x113 = x11[:,:,:,:,4:]
        #concat
        x11 = torch.cat((x111, x112, x113), -1)
        x11 = x11.reshape([1, -1, 10])
        '''------------------------------------------'''

        '''---------------------2--------------------'''
        x121 = self.Sigmoid(x121)
        # slice
        x1211 = x121[:,:,:,:,2:4]
        x1211 = x1211 * 2
        x1211 = x1211 - 0.5
        x1211 = x1211 + b3
        x1211 = x1211 * 16
        # slice
        x1212 = x121[:,:,:,:,2:4]
        x1212 = x1212 * 2
        x1212 = pow(x1212, 2)
        x1212 = x1212 * b4
        # slice
        x1213 = x121[:,:,:,:,4:]
        # concat
        x121 = torch.cat((x1211, x1212, x1213), -1)
        x121 = x121.reshape([1, -1, 10])
        '''------------------------------------------'''

        '''--------------------3---------------------'''
        x22 = self.Sigmoid(x22)
        # slice
        x221 = x22[:,:,:,:,2:4]
        x221 = x221 * 2
        x221 = x221 - 0.5
        x221 = x221 + b5
        x221 = x221 * 32
        # slice
        x222 = x22[:,:,:,:,2:4]
        x222 = x222 * 2
        x222 = pow(x222, 2)
        x222 = x222 * b6
        # slice
        x223 = x22[:,:,:,:,4:]
        # concat
        x22 = torch.cat((x221, x222, x223), -1)
        x22 = x22.reshape([1, -1, 10])
        '''------------------------------------------'''
        x = x22 = torch.cat((x11, x121, x22), 1)
        return x


# model
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
net = yolov5s().to(device)

# 权重偏差赋值
# weight
net.conv_0.weight.data= torch.from_numpy(np.load(r'.\parameters\model.0.conv.weight.npy').astype(np.float32))
net.conv_3.weight.data= torch.from_numpy(np.load(r'.\parameters\model.1.conv.weight.npy').astype(np.float32))
net.conv_6.weight.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv1.conv.weight.npy').astype(np.float32))
net.conv_9.weight.data= torch.from_numpy(np.load(r'.\parameters\model.2.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_12.weight.data= torch.from_numpy(np.load(r'.\parameters\model.2.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_16.weight.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv2.conv.weight.npy').astype(np.float32))
net.conv_20.weight.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv3.conv.weight.npy').astype(np.float32))
net.conv_23.weight.data= torch.from_numpy(np.load(r'.\parameters\model.3.conv.weight.npy').astype(np.float32))
net.conv_26.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv1.conv.weight.npy').astype(np.float32))
net.conv_29.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_32.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_36.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.1.cv1.conv.weight.npy').astype(np.float32))
net.conv_39.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.1.cv2.conv.weight.npy').astype(np.float32))
net.conv_43.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv2.conv.weight.npy').astype(np.float32))
net.conv_47.weight.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv3.conv.weight.npy').astype(np.float32))
net.conv_50.weight.data= torch.from_numpy(np.load(r'.\parameters\model.5.conv.weight.npy').astype(np.float32))
net.conv_53.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv1.conv.weight.npy').astype(np.float32))
net.conv_56.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_59.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_63.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.1.cv1.conv.weight.npy').astype(np.float32))
net.conv_66.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.1.cv2.conv.weight.npy').astype(np.float32))
net.conv_70.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.2.cv1.conv.weight.npy').astype(np.float32))
net.conv_73.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.2.cv2.conv.weight.npy').astype(np.float32))
net.conv_77.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv2.conv.weight.npy').astype(np.float32))
net.conv_81.weight.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv3.conv.weight.npy').astype(np.float32))
net.conv_84.weight.data= torch.from_numpy(np.load(r'.\parameters\model.7.conv.weight.npy').astype(np.float32))
net.conv_87.weight.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv1.conv.weight.npy').astype(np.float32))
net.conv_90.weight.data= torch.from_numpy(np.load(r'.\parameters\model.8.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_93.weight.data= torch.from_numpy(np.load(r'.\parameters\model.8.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_97.weight.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv2.conv.weight.npy').astype(np.float32))
net.conv_101.weight.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv3.conv.weight.npy').astype(np.float32))
net.conv_104.weight.data= torch.from_numpy(np.load(r'.\parameters\model.9.cv1.conv.weight.npy').astype(np.float32))
net.conv_111.weight.data= torch.from_numpy(np.load(r'.\parameters\model.9.cv2.conv.weight.npy').astype(np.float32))
net.conv_114.weight.data= torch.from_numpy(np.load(r'.\parameters\model.10.conv.weight.npy').astype(np.float32))
net.conv_120.weight.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv1.conv.weight.npy').astype(np.float32))
net.conv_123.weight.data= torch.from_numpy(np.load(r'.\parameters\model.13.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_126.weight.data= torch.from_numpy(np.load(r'.\parameters\model.13.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_129.weight.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv2.conv.weight.npy').astype(np.float32))
net.conv_133.weight.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv3.conv.weight.npy').astype(np.float32))
net.conv_136.weight.data= torch.from_numpy(np.load(r'.\parameters\model.14.conv.weight.npy').astype(np.float32))
net.conv_142.weight.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv1.conv.weight.npy').astype(np.float32))
net.conv_145.weight.data= torch.from_numpy(np.load(r'.\parameters\model.17.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_148.weight.data= torch.from_numpy(np.load(r'.\parameters\model.17.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_151.weight.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv2.conv.weight.npy').astype(np.float32))
net.conv_155.weight.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv3.conv.weight.npy').astype(np.float32))
net.conv_158.weight.data= torch.from_numpy(np.load(r'.\parameters\model.18.conv.weight.npy').astype(np.float32))
net.conv_162.weight.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv1.conv.weight.npy').astype(np.float32))
net.conv_165.weight.data= torch.from_numpy(np.load(r'.\parameters\model.20.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_168.weight.data= torch.from_numpy(np.load(r'.\parameters\model.20.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_171.weight.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv2.conv.weight.npy').astype(np.float32))
net.conv_175.weight.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv3.conv.weight.npy').astype(np.float32))
net.conv_178.weight.data= torch.from_numpy(np.load(r'.\parameters\model.21.conv.weight.npy').astype(np.float32))
net.conv_182.weight.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv1.conv.weight.npy').astype(np.float32))
net.conv_185.weight.data= torch.from_numpy(np.load(r'.\parameters\model.23.m.0.cv1.conv.weight.npy').astype(np.float32))
net.conv_188.weight.data= torch.from_numpy(np.load(r'.\parameters\model.23.m.0.cv2.conv.weight.npy').astype(np.float32))
net.conv_191.weight.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv2.conv.weight.npy').astype(np.float32))
net.conv_195.weight.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv3.conv.weight.npy').astype(np.float32))
net.conv_198.weight.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.0.weight.npy').astype(np.float32))
net.conv_233.weight.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.1.weight.npy').astype(np.float32))
net.conv_268.weight.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.2.weight.npy').astype(np.float32))


# bias
net.conv_0.bias.data= torch.from_numpy(np.load(r'.\parameters\model.0.conv.bias.npy').astype(np.float32))
net.conv_3.bias.data= torch.from_numpy(np.load(r'.\parameters\model.1.conv.bias.npy').astype(np.float32))
net.conv_6.bias.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv1.conv.bias.npy').astype(np.float32))
net.conv_9.bias.data= torch.from_numpy(np.load(r'.\parameters\model.2.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_12.bias.data= torch.from_numpy(np.load(r'.\parameters\model.2.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_16.bias.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv2.conv.bias.npy').astype(np.float32))
net.conv_20.bias.data= torch.from_numpy(np.load(r'.\parameters\model.2.cv3.conv.bias.npy').astype(np.float32))
net.conv_23.bias.data= torch.from_numpy(np.load(r'.\parameters\model.3.conv.bias.npy').astype(np.float32))
net.conv_26.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv1.conv.bias.npy').astype(np.float32))
net.conv_29.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_32.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_36.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.1.cv1.conv.bias.npy').astype(np.float32))
net.conv_39.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.m.1.cv2.conv.bias.npy').astype(np.float32))
net.conv_43.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv2.conv.bias.npy').astype(np.float32))
net.conv_47.bias.data= torch.from_numpy(np.load(r'.\parameters\model.4.cv3.conv.bias.npy').astype(np.float32))
net.conv_50.bias.data= torch.from_numpy(np.load(r'.\parameters\model.5.conv.bias.npy').astype(np.float32))
net.conv_53.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv1.conv.bias.npy').astype(np.float32))
net.conv_56.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_59.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_63.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.1.cv1.conv.bias.npy').astype(np.float32))
net.conv_66.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.1.cv2.conv.bias.npy').astype(np.float32))
net.conv_70.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.2.cv1.conv.bias.npy').astype(np.float32))
net.conv_73.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.m.2.cv2.conv.bias.npy').astype(np.float32))
net.conv_77.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv2.conv.bias.npy').astype(np.float32))
net.conv_81.bias.data= torch.from_numpy(np.load(r'.\parameters\model.6.cv3.conv.bias.npy').astype(np.float32))
net.conv_84.bias.data= torch.from_numpy(np.load(r'.\parameters\model.7.conv.bias.npy').astype(np.float32))
net.conv_87.bias.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv1.conv.bias.npy').astype(np.float32))
net.conv_90.bias.data= torch.from_numpy(np.load(r'.\parameters\model.8.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_93.bias.data= torch.from_numpy(np.load(r'.\parameters\model.8.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_97.bias.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv2.conv.bias.npy').astype(np.float32))
net.conv_101.bias.data= torch.from_numpy(np.load(r'.\parameters\model.8.cv3.conv.bias.npy').astype(np.float32))
net.conv_104.bias.data= torch.from_numpy(np.load(r'.\parameters\model.9.cv1.conv.bias.npy').astype(np.float32))
net.conv_111.bias.data= torch.from_numpy(np.load(r'.\parameters\model.9.cv2.conv.bias.npy').astype(np.float32))
net.conv_114.bias.data= torch.from_numpy(np.load(r'.\parameters\model.10.conv.bias.npy').astype(np.float32))
net.conv_120.bias.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv1.conv.bias.npy').astype(np.float32))
net.conv_123.bias.data= torch.from_numpy(np.load(r'.\parameters\model.13.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_126.bias.data= torch.from_numpy(np.load(r'.\parameters\model.13.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_129.bias.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv2.conv.bias.npy').astype(np.float32))
net.conv_133.bias.data= torch.from_numpy(np.load(r'.\parameters\model.13.cv3.conv.bias.npy').astype(np.float32))
net.conv_136.bias.data= torch.from_numpy(np.load(r'.\parameters\model.14.conv.bias.npy').astype(np.float32))
net.conv_142.bias.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv1.conv.bias.npy').astype(np.float32))
net.conv_145.bias.data= torch.from_numpy(np.load(r'.\parameters\model.17.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_148.bias.data= torch.from_numpy(np.load(r'.\parameters\model.17.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_151.bias.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv2.conv.bias.npy').astype(np.float32))
net.conv_155.bias.data= torch.from_numpy(np.load(r'.\parameters\model.17.cv3.conv.bias.npy').astype(np.float32))
net.conv_158.bias.data= torch.from_numpy(np.load(r'.\parameters\model.18.conv.bias.npy').astype(np.float32))
net.conv_162.bias.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv1.conv.bias.npy').astype(np.float32))
net.conv_165.bias.data= torch.from_numpy(np.load(r'.\parameters\model.20.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_168.bias.data= torch.from_numpy(np.load(r'.\parameters\model.20.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_171.bias.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv2.conv.bias.npy').astype(np.float32))
net.conv_175.bias.data= torch.from_numpy(np.load(r'.\parameters\model.20.cv3.conv.bias.npy').astype(np.float32))
net.conv_178.bias.data= torch.from_numpy(np.load(r'.\parameters\model.21.conv.bias.npy').astype(np.float32))
net.conv_182.bias.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv1.conv.bias.npy').astype(np.float32))
net.conv_185.bias.data= torch.from_numpy(np.load(r'.\parameters\model.23.m.0.cv1.conv.bias.npy').astype(np.float32))
net.conv_188.bias.data= torch.from_numpy(np.load(r'.\parameters\model.23.m.0.cv2.conv.bias.npy').astype(np.float32))
net.conv_191.bias.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv2.conv.bias.npy').astype(np.float32))
net.conv_195.bias.data= torch.from_numpy(np.load(r'.\parameters\model.23.cv3.conv.bias.npy').astype(np.float32))
net.conv_198.bias.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.0.bias.npy').astype(np.float32))
net.conv_233.bias.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.1.bias.npy').astype(np.float32))
net.conv_268.bias.data= torch.from_numpy(np.load(r'.\parameters\model.24.m.2.bias.npy').astype(np.float32))



if __name__ == "__main__":
    print("fuck")