import torch
import torch.nn as nn
import numpy as np
from weight import *

class model(nn.Module):
    def __init__(self):
        super(model, self).__init__()
        self.maxpool = nn.MaxPool2d(5, 1, 2)
        self.Sigmoid = nn.Sigmoid()
        self.conv_0 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=6,
                                 stride=2,
                                 padding=2,
                                 bias=True)
        self.conv_3 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=2,
                                 padding=1,
                                 bias=True)
        self.conv_6 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=1,
                                 stride=1,
                                 padding=0,
                                 bias=True)
        self.conv_9 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_12 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_16 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_20 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_23 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_26 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_29 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_32 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_36 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_39 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_43 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_47 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_50 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_53 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_56 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_59 = nn.Conv2d(in_channels=1,
                               out_channels=1,
                               kernel_size=3,
                               stride=1,
                               padding=1,
                               bias=True)
        self.conv_63 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_66 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_70 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_73 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_77 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_81 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_84 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_87 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_90 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_93 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_97 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_101 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_104 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_111 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_114 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_120 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_123 = nn.Conv2d(in_channels=1,
                                 out_channels=1,
                                 kernel_size=3,
                                 stride=1,
                                 padding=1,
                                 bias=True)
        self.conv_126 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_129 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_133 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_136 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_142 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_145 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_148 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_151 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_155 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_158 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_162 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_165 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_168 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_171 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_175 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_178 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_182 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_185 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_188 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_191 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_195 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_198 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_233 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_268 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_123 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)
        self.conv_123 = nn.Conv2d(in_channels=1,
                                  out_channels=1,
                                  kernel_size=3,
                                  stride=1,
                                  padding=1,
                                  bias=True)





        self.sigmoid = nn.Sigmoid()
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
        # resize
        x221 =
        # concat
        x21 = torch.cat((x21,x221),1)

        x211 = self.conv_104(x21)
        x211 = x211 * self.Sigmoid(x211)
        x211 = self.conv_104(x211)
        x211 = x211 * self.Sigmoid(x211)
        x211 = self.conv_104(x211)
        x211 = x21 * self.Sigmoid(x211)
        x212 = self.conv_104(x21)
        x212 = x212 * self.Sigmoid(x212)
        # concat
        x21 = torch.cat((x211,x212),1)

        x21 = self.conv_104(x21)
        x21 = x21 * self.Sigmoid(x21)
        x21 = self.conv_104(x21)
        x21 = x21 * self.Sigmoid(x21)
        # resize
        x211 =
        # concat
        x1 = torch.cat((x,x221),1)

        x11 = self.conv_104(x1)
        x11 = x11 * self.Sigmoid(x11)
        x11 = self.conv_104(x11)
        x11 = x11 * self.Sigmoid(x11)
        x11 = self.conv_104(x11)
        x11 = x11 * self.Sigmoid(x11)
        x12 = self.conv_104(x1)
        x12 = x12 * self.Sigmoid(x12)
        #concat
        x1 = torch.cat((x11,x12),1)

        x1 = self.conv_104(x1)
        x1 = x1 * self.Sigmoid(x1)

        '''-----------------over1--------------------'''
        x11 = self.conv_104(x1)
        # reshape
        x11 = x11.reshape([1,3,10,80,80])
        # transpose
        x11.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        x12 = self.conv_104(x1)
        x12 = x12 * self.Sigmoid(x12)
        # concat
        x12 = torch.cat((x12,x21),1)

        x121 = self.conv_104(x12)
        x121 = x121 * self.Sigmoid(x121)
        x121 = self.conv_104(x121)
        x121 = x121 * self.Sigmoid(x121)
        x121 = self.conv_104(x121)
        x121 = x121 * self.Sigmoid(x121)
        x122 = self.conv_104(x12)
        x122 = x122 * self.Sigmoid(x122)
        #concat
        x12 = torch.cat((x121,x122),1)

        x12 = self.conv_104(x12)
        x12 = x12 * self.Sigmoid(x12)
        '''-----------------over2--------------------'''
        x121 = self.conv_104(x12)
        # reshape
        x121 = x121.reshape([1, 3, 10, 40, 40])
        # transpose
        x121.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        x122 = self.conv_104(x12)
        x122 = x122 * self.Sigmoid(x122)
        # concat
        x22 = torch.cat((x22,x122),1)

        x221 = self.conv_104(x22)
        x221 = x221 * self.Sigmoid(x221)
        x221 = self.conv_104(x221)
        x221 = x221 * self.Sigmoid(x221)
        x221 = self.conv_104(x221)
        x221 = x221 * self.Sigmoid(x221)
        x222 = self.conv_104(x22)
        x222 = x222 * self.Sigmoid(x222)
        # concat
        x22 = torch.cat((x221,x222),1)

        x22 = self.conv_104(x22)
        x22 = x22 * self.Sigmoid(x22)
        '''-----------------over3--------------------'''
        x22 = self.conv_104(x22)
        # reshape
        x22 = x22.reshape([1, 3, 10, 20, 20])
        # transpose
        x22.permute(0, 1, 3, 4, 2)
        '''------------------------------------------'''

        '''--------------------1---------------------'''
        x11 = self.Sigmoid(x11)
        # slice
        x111 =
        x111 = x111 * 2
        x111 = x111 - 0.5
        x111 = x111 + b1
        x111 = x111 * 8
        # slice
        x112 =
        x112 = x112 * 2
        x112 = pow(x112,2)
        x112 = x112 * b2
        # slice
        x113 =
        #concat
        x11 = torch.cat((x111, x112, x113), -1)
        x11 = x11.reshape([1, -1, 10])
        '''------------------------------------------'''

        '''---------------------2--------------------'''
        x121 = self.Sigmoid(x121)
        # slice
        x1211 =
        x1211 = x1211 * 2
        x1211 = x1211 - 0.5
        x1211 = x1211 + b3
        x1211 = x1211 * 16
        # slice
        x1212 =
        x1212 = x1212 * 2
        x1212 = pow(x1212, 2)
        x1212 = x1212 * b4
        # slice
        x1213 =
        # concat
        x121 = torch.cat((x1211, x1212, x1213), -1)
        x121 = x121.reshape([1, -1, 10])
        '''------------------------------------------'''

        '''--------------------3---------------------'''
        x22 = self.Sigmoid(x22)
        # slice
        x221 =
        x221 = x221 * 2
        x221 = x221 - 0.5
        x221 = x221 + b5
        x221 = x221 * 32
        # slice
        x222 =
        x222 = x222 * 2
        x222 = pow(x222, 2)
        x222 = x222 * b6
        # slice
        x223 =
        # concat
        x22 = torch.cat((x221, x222, x223), -1)
        x22 = x22.reshape([1, -1, 10])
        '''------------------------------------------'''
        x = x22 = torch.cat((x11, x121, x22), 1)
        return x


if __name__ == "__main__":
    print("fuck")