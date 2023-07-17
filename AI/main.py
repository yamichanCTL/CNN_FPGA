import time

from main_lib import *

if __name__ == "__main__":
    # t0 = threading.Thread(target=udp_recv)
    # t0.start()
    # t1 = threading.Thread(target=detect(r_img))
    # t1.start()

    # #udp
    # while True:
    #     detect_udp(r_img)


    while True:
        detect_hdmi()
        if cv2.waitKey(1) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break
        # print(len(r_img))
    # while True:
    #     print(flag)
        # if flag == True:
        #     detect(r_img)
        #     flag = False