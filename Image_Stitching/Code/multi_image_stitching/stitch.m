function im3 = stitch (img1,img2)
%读入数据
image1= img1;
image2= img2;
%查找特征点
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);
%特征点匹配+显示
[pt1,pt2] = match(im1,des1,loc1,im2,des2,loc2);
%图像拼接+显示
im3 = transform(pt1,pt2,img1,img2);
imwrite(uint8(im3),'final.jpg')
im3 = 'final.jpg';