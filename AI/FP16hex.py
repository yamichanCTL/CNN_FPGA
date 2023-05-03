import struct
import numpy as np
# dec_float = 5.9
# dec_float = np.array([[[1, 2],
#                  [3, 4],
#                  [5, 6]]]).astype(np.float16)
# print(dec_float.shape[-2])

# 十进制单精度浮点转16位16进制
def float16_FP16(data,filepath):
    data.astype(np.float16)
    d0 = data.shape[0]
    d1 = data.shape[1]
    d2 = data.shape[2]
    d3 = data.shape[3]
    test = [[[[0 for i in range(d3)] for j in range(d2)] for k in range(d1)] for l in range(d0)]
    with open(filepath, 'a') as f:
        for i in range(d0):
            for j in range(d1):
                for k in range(d2):
                    for l in range(d3):
                        test[i][j][k][l] = struct.unpack('H',struct.pack('e',data[i][j][k][l]))[0]
                        test[i][j][k][l] = bin(test[i][j][k][l])[2:]
                        f.write('%s\n' % test[i][j][k][l])
                        # np.savetxt(f, test[i][j], fmt="%s", newline='\n')
# hexa = struct.unpack('H',struct.pack('e',1))[0]
# hexa = bin(hexa)
# hexa = hexa[2:] # 去掉0x 0b
# print(hexa) # 45e6
# hexa = [[hexa, hexa, hexa],[hexa]]
# np.savetxt('./parameters/test.txt', dec_float, fmt="%s", newline='\n') # 没必要固定位宽，之后可以弄
#
#




# # 16位16进制转十进制单精度浮点
# y = struct.pack("H",int(hexa,16))
# float = np.frombuffer(y, dtype =np.float16)[0]
# print(float) # 5.9

