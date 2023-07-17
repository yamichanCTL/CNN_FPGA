import torch
import time
import cv2

yolo_path = r'G:/college/machine learning/yolov5-6.1'
yolo_lite = r'G:/project/IC/CICC2023/yolov5-Lite-master'
pt_path = r'../model/jiaotongv5n.pt'
img_path = r'../pic/daySequence1--00102.jpg'
output_path = '../pic/bus0.jpg'
size = 640

def detect_show(org_img, boxs,FPS):
    img = org_img.copy()
    for box in boxs:
        # rectangle画框，参数表示依次为：(图片，长方形框左上角坐标, 长方形框右下角坐标， 字体颜色，字体粗细)
        cv2.rectangle(img, (int(box[0]), int(box[1])), (int(box[2]), int(box[3])), (0, 0, 255), 2)  ###?
        # putText各参数依次是：图片，添加的文字(标签+深度-单位m)，左上角坐标，字体，字体大小，颜色，字体粗细
        cv2.putText(img, 'confidence:' + str(box[4]), (int(box[0]), int(box[1]-10)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
        cv2.putText(img, 'class:' + box[6], (int(box[0]), int(box[1]-30)),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
        cv2.putText(img, 'FPS:' + str(FPS), (50, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.75, (0, 255, 0), 2)
    cv2.imshow('dec_img', img)
    cv2.waitKey(10)

if __name__ == "__main__":
    #load model
    model = torch.hub.load(yolo_path,
                           'custom',
                           path=pt_path,
                           source='local',
                           force_reload=True)  # 加载模型
    model.conf = 0.5  # NMS confidence threshold
    model.iou = 0.45  # NMS IoU threshold
          # agnostic = False  # NMS class-agnostic
          # multi_label = False  # NMS multiple labels per box
          # classes = None  # (optional list) filter by class, i.e. = [0, 15, 16] for COCO persons, cats and dogs
          # max_det = 1000  # maximum number of detections per image
          # amp = False  # Automatic Mixed Precision (AMP) inference
    # # choose device
    # model.cpu()  # CPU
    model.cuda()  # GPU
    # model.to(device)  # i.e. device=torch.device(0)
    model.eval()

    # or_img = cv2.imread(img_path)
    # convert_img = cv2.cvtColor(or_img, cv2.COLOR_BGR2RGB)

    cap = cv2.VideoCapture(0)  # 名为'003.mp4'的文件
    cap.set(3, 1500)
    cap.set(4, 900)
    # Inference
    while True:
        # 视频
        ret, or_img = cap.read()
        # # IMG
        convert_img = cv2.cvtColor(or_img, cv2.COLOR_BGR2RGB)

        time0 = time.perf_counter()
        results = model(convert_img)
        boxs = results.pandas().xyxy[0].values
        time1 = time.perf_counter()
        FPS = int(1/(time1-time0))
        detect_show(or_img, boxs, FPS)

        # Press esc or 'q' to close the image window
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        # key = cv2.waitKey(1)
        # if key & 0xFF == ord('q') or key == 27:
        #     cv2.destroyAllWindows()
        #     break
        # print(time1-time0)
    cv2.destroyAllWindows()


