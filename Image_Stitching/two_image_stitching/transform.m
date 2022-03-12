function ImMerge = transform(pt1,pt2)
[tform,  inlierPts2, inlierPt1] = estimateGeometricTransform(pt2,pt1,'Similarity');
% ����ģ��ı任
tform0 = projective2d(eye(3));
% ����ͼƬ�任��ķ�Χ
im1 = imread('1.jpg');
im2 = imread('2.jpg');
imsize1=size(im1);
imsize2=size(im2);
imsizem1=max([imsize1(1),imsize2(1)]);
imsizem2=max([imsize1(2),imsize2(2)]);
% ����ͼƬ�ռ�任��Χ
[xlim, ylim]=outputLimits(tform,[1 imsizem2],[1 imsizem1]);
xMin=min([1; xlim(:)]);
xMax=max([imsizem2; xlim(:)]);
yMin=min([1;ylim(:)]);
yMax=max([imsizem1;ylim(:)]);
width=round(xMax-xMin);
height=round(yMax-yMin);
ImMerge=zeros(height,width,3);
xLimits = [xMin xMax];
yLimits = [yMin yMax];
% ���µ�ͼƬ��Χ��������ϵ
panoramaView = imref2d([height width], xLimits, yLimits);
%��ͼ1ʵʩ�任
Jregistered1 = imwarp(im1,tform0,'OutputView',panoramaView);
mask1 = imwarp(true(size(im1,1),size(im1,2)),tform0,'OutputView',panoramaView);
%��ͼ2ʵʩ�任
Jregistered2 = imwarp(im2,tform,'OutputView',panoramaView);
mask2 = imwarp(true(size(im2,1),size(im2,2)),tform,'OutputView',panoramaView);

% �鿴�任��ͼƬ
figure;
imshowpair(Jregistered1,Jregistered2)
title('�任��ͼƬ');

%% ͼƬֱ�ӵ���Ч��
blender=vision.AlphaBlender('Operation','Binary mask',...
    'MaskSource','Input port');
ImMerge=step(blender,ImMerge,double(Jregistered2),mask2);
ImMerge=step(blender,ImMerge,double(Jregistered1),mask1);
figure;
imshow(uint8(ImMerge))
title('ͼƬֱ�ӵ���Ч��');