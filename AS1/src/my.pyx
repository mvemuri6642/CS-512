def grayscale_cython(img, height,width,gray_img_v3):
    cdef int i,j,r,g,b
    cdef double grayscale_array[3]
    grayscale_array[0]=0.2989
    grayscale_array[1]=0.5870
    grayscale_array[2]=0.1140
    for i in range(height):
        for j in range(width):
            r,g,b=img[i][j]
            gray_pix=grayscale_array[0]*r+grayscale_array[1]*g+grayscale_array[2]*b
            gray_img_v3[i][j]=gray_pix
    return gray_img_v3