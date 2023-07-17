import numpy as np
from binascii import unhexlify

data = np.array([[1, 2],
                 [3, 4]]).astype(np.float16)
# print(np.binary_repr(0.1, width=16)) # 只能转整数
data.tofile('./parameters/test.bin')
# # np.save('./parameters/test', data)

np.savetxt('./parameters/test.txt', data, fmt="%s", newline='\n')
# np.savetxt('./parameters/test.bin', np.vectorize(np.binary_repr)(data, width=16), fmt='%s', newline='\n')


print(bin(np.float16(1).view('H'))) # .view('H')将float16值占用的内存重新解释为无符号整数
print(np.float16(1.).tobytes())
# arr = np.fromfile('./parameters/test.bin', dtype=np.float16)
# # 将数组保存为文本文件
# np.savetxt('./parameters/test.txt', arr)
# np.frombuffer(b'\x3c\x00', np.float16)
# np.frombuffer(b'\x00\x3c', np.float16)
