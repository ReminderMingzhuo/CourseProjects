function fuse(ImMerge)
%% ͼƬֱ�ӵ���Ч��
blender=vision.AlphaBlender('Operation','Binary mask',...
    'MaskSource','Input port');
ImMerge=step(blender,ImMerge,double(Jregistered2),mask2);
ImMerge=step(blender,ImMerge,double(Jregistered1),mask1);
figure;
imshow(uint8(ImMerge))
title('ͼƬֱ�ӵ���Ч��');
