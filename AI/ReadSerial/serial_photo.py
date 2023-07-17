# coding: utf-8
from PIL import Image
import numpy as np
from PyQt5.QtCore import QThread, pyqtSignal
from PyQt5.QtGui import QPixmap, QImage
from serial import Serial


def imageToQPixmap(image: Image.Image):
    """ 将图像转换为 `QPixmap`

    Parameters
    ----------
    image: `~PIL.Image` or `np.ndarray`
        RGB 图像
    """
    image = np.array(image)  # type:np.ndarray
    h, w, c = image.shape
    format = QImage.Format_RGB888 if c == 3 else QImage.Format_RGBA8888
    return QPixmap.fromImage(QImage(image.data, w, h, c * w, format))


def rgb565ToImage(pixels: list) -> QPixmap:
    """ 将 RGB565 图像转换为 RGB888 """
    image = []
    for i in range(0, len(pixels), 2):
        pixel = (pixels[i] << 8) | pixels[i+1]
        r = pixel >> 11
        g = (pixel >> 5) & 0x3f
        b = pixel & 0x1f
        r = r * 255.0 / 31.0
        g = g * 255.0 / 63.0
        b = b * 255.0 / 31.0
        image.append([r, g, b])

    image = np.array(image, dtype=np.uint8).reshape(
        (240, 320, 3)).transpose((1, 0, 2))
    return imageToQPixmap(Image.fromarray(image))


class SerialThread(QThread):
    """ 串口线程 """

    loadImageFinished = pyqtSignal(QPixmap)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.serial = Serial(baudrate=115200)
        self.isStopped = False

    def run(self):
        """ 将串口传输的字节转换为图像 """
        data = []
        self.serial.port = config.get(config.serialPort)

        with self.serial as s:
            while not self.isStopped:
                if not s.isOpen():
                    s.open()

                # 等待 header
                header = s.readline()[:-1]
                if header.decode("utf-8", "replace") != "image:":
                    continue

                # 读入像素，丢弃换行符
                column_len = 320*2+1
                while len(data) < 2*320*240:
                    image_line = s.read(column_len)
                    data.extend(image_line[:-1])

                self.loadImageFinished.emit(rgb565ToImage(data))
                data.clear()

    def stop(self):
        """ 停止从串口读取图像 """
        self.isStopped = True
        self.serial.close()

    def loadImage(self):
        """ 开始从串口读取图像 """
        self.isStopped = False
        self.start()
