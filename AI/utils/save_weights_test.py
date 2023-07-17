from AI.utils.FP16hex import *
weight = np.load('../parameters/model.2.cv3.conv.weight.npy')
print(weight.shape)
float16_FP16(weight,"./parameters/test_weight.txt")