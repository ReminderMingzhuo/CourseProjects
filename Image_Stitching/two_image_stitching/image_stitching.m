clear
tic
%��������
image1='1.jpg';
image2='2.jpg';
%����������
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);
%������ƥ��+��ʾ
[pt1,pt2] = match(im1,des1,loc1,im2,des2,loc2);
%ͼ��ƴ��+��ʾ
im3 = transform(pt1,pt2);
%ƴ��ͼ��洢
imwrite(uint8(im3),'ƴ��ͼ��.jpg')
toc