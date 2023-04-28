import math
import numpy as np
import cv2 as cv2
def rotation_matrix(img,angle):
    cdef int height=img.shape[0]
    cdef int width=img.shape[1]
    cdef float center_x=width//2
    cdef float center_y=height//2
    angle_rad=-angle * math.pi / 180
    rotation_matrix = np.array([[np.cos(angle_rad), -np.sin(angle_rad), 0],[np.sin(angle_rad), np.cos(angle_rad), 0],[0, 0, 1]])
    trans_matrix = np.array([[1, 0, center_x],
                                 [0, 1, center_y],
                                 [0, 0, 1]])
    inv_trans_matrix = np.array([[1, 0, -center_x],
                                 [0, 1, -center_y],
                                 [0, 0, 1]])
    new_=np.dot(np.dot(trans_matrix,rotation_matrix),inv_trans_matrix)
    return new_

def warp_affine(img,angle):
    cdef int height=img.shape[0]
    cdef int width=img.shape[1]
    rotate_matrix=rotation_matrix(img,angle)
    rotate_matrix = np.array(rotate_matrix, dtype=np.float32)
    #rotate_matrix = cv2.getRotationMatrix2D(center=center, angle=angle, scale=1)
    rotated_image = cv2.warpAffine(src=img, M=rotate_matrix[:2], dsize=(width, height))
    return rotated_image

def nothing(x):
    pass

def rotation_warp(angle,img):
    cv2.namedWindow('controls')
    cv2.createTrackbar('r','controls',0,360,nothing)

    cdef int height=img.shape[0]
    cdef int width=img.shape[1]
    #center = (width/2, height/2)
    while(1):
        angle= int(cv2.getTrackbarPos('r','controls'))
        rotated_image=warp_affine(img,angle)
        cv2.imshow('image',rotated_image)
        cv2.setWindowProperty('image', 1, cv2.WINDOW_NORMAL)
        cv2.resizeWindow('image', height, width)
        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break
    cv2.destroyAllWindows()