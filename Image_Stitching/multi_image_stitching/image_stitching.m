clear
tic
%读入数据
image1='1.jpg';
image2='2.jpg';
%查找特征点
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);
%特征点匹配+显示
[pt1,pt2] = match(im1,des1,loc1,im2,des2,loc2);
%图像拼接+显示
im3 = transform(pt1,pt2);
%拼接图像存储
imwrite(uint8(im3),'拼接图像.jpg')
toc