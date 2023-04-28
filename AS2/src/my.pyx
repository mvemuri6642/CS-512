import numpy as np
import cv2 as cv2
def img_smooth(image, kernel):
    cdef int input_height= image.shape[0]
    cdef int input_width=image.shape[1]
    cdef int channels = image.shape[2]
    cdef int kernel_height=kernel.shape[0]
    cdef int kernel_width = kernel.shape[1]
    cdef int output_height = input_height
    cdef int output_width = input_width
    
    cdef int p_height=kernel_height//2
    cdef int p_width=kernel_width//2
    cdef unsigned char[:,:,:] padded_image=np.pad(image,((p_height,p_height),(p_width,p_width),(0,0)),mode='constant')
    
    cdef unsigned char[:,:,:] output = np.zeros((output_height, output_width,3),dtype='uint8')
    cdef unsigned char[:,:] new_img;
    for c in range(channels):
        new_img=padded_image[:,:,c]
        for i in range(output_height):
            for j in range(output_width):
                output[i, j,c] = np.sum(new_img[i:i+kernel_height, j:j+kernel_width] * kernel)
    return output

def nothing(x):
    pass


def apply_smooth(img):
    cv2.namedWindow('controls')
    cv2.createTrackbar('r','controls',0,255,nothing)
    cdef int height=img.shape[0]
    cdef int width=img.shape[1]
    while(1):
        smooth= int(cv2.getTrackbarPos('r','controls'))
        kernel = np.ones((smooth, smooth), dtype=np.float32) / (smooth**2)
        new=img_smooth(img,kernel)
        new=np.array(new)
        cv2.imshow('image',new)
        cv2.setWindowProperty('image', 1, cv2.WINDOW_NORMAL)
        cv2.resizeWindow('image', height, width)
        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break
    cv2.destroyAllWindows()