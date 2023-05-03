import onnx

onnx.utils.extract_model('./model/batch1_640_640.onnx', './model/batch1_640_640_part1.onnx', ['images'], ['input.16'])
onnx.utils.extract_model('./model/batch1_640_640.onnx', './model/batch1_640_640_part2.onnx', ['input.20'], ['output'])