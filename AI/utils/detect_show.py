import cv2
# 这个函数主要是在原图上画框,标出深度信息,此外用毫米看比较方便
def detect_show(org_img, boxs):
    img = org_img.copy()
    for box in boxs:
        text_pixel = str((int(box[0]) + int(box[2])) // 2) + ', ' + str((int(box[1]) + int(box[3])) // 2) + '(pixel)'

        # rectangle画框，参数表示依次为：(图片，长方形框左上角坐标, 长方形框右下角坐标， 字体颜色，字体粗细)
        cv2.rectangle(img, (int(box[0]), int(box[1])), (int(box[2]), int(box[3])), (0, 255, 0), 2)  ###?
        # circle画圆心，参数表示依次为：(img, center, radius, color[, thickness]),thickness为负表示绘制实心圆
        center = [(int(box[0]) + int(box[2])) // 2, (int(box[1]) + int(box[3])) // 2]
        cv2.circle(img, center, 8, (0, 255, 0), -1)

        # putText各参数依次是：图片，添加的文字(标签+深度-单位m)，左上角坐标，字体，字体大小，颜色，字体粗细
        cv2.putText(img, 'cup_position_in_pixel:' + text_pixel,
                    (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        # cv2.putText(img, 'cup_position_in_base:' + text_base, (50, 150), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    cv2.imshow('dec_img', img)