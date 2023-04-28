import numpy as np
import cv2 as cv2
import math
def rotate_image(img,angle,inv):
    cdef int height=img.shape[0]
    cdef int width=img.shape[1]
    cdef int channels=img.shape[2]
    cdef double center_x=width//2
    cdef double center_y=height//2
    rotated_image=np.zeros((height,width,3),dtype=np.uint8)
    cdef float angle_rad=-angle * math.pi / 180
    #angle_rad=angle
    cdef int i,j
    rotation_matrix = np.array([[np.cos(angle_rad), -np.sin(angle_rad), 0],[np.sin(angle_rad), np.cos(angle_rad), 0],[0, 0, 1]])    
    for i in range(height):
        for j in range(width):
            trans_matrix = np.array([[1, 0, center_x],
                                 [0, 1, center_y],
                                 [0, 0, 1]])
            inv_trans_matrix = np.array([[1, 0, -center_x],
                                 [0, 1, -center_y],
                                 [0, 0, 1]])
            if(inv==1):
                new_inv=np.linalg.inv(np.dot(np.dot(trans_matrix,rotation_matrix),inv_trans_matrix))
                new_=np.dot(new_inv,[j,i,1])[:2]
            elif(inv==0):
                new_=np.dot(np.dot(np.dot(trans_matrix,rotation_matrix),inv_trans_matrix),[j,i,1])[:2]
            #new_=np.dot(np.dot(np.dot(inv_trans_matrix,[j,i,1]),rotation_matrix),trans_matrix)[:2]
            X=int(new_[0])
            y=int(new_[1])
            #print(X,y)
            if 0 <= X < width and 0 <= y < height:
                rotated_image[y,X] = img[i,j]
                
    return rotated_image