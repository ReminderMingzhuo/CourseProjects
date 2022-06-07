function timg = tailor(img)
%读入数据
im=imread(img);
imsize=size(im);
%查找最右端黑边界限
for m=imsize(1):-1:1
    for n=imsize(2):-1:1
    if im(m,n)>0
        break;
    end
    end
    if n>1
        break;
    end
end
m0=m;
%查找最低端黑边界限
for n=imsize(2):-1:1
    for m=imsize(1):-1:1
    if im(m,n)>0
        break;
    end
    end
    if m>1
        break;
    end
end
n0=n;
%图像裁剪并显示
timg = imcrop(im,[1 1 n0-1 m0-1]);
figure;
imshow(uint8(timg));
title('去除黑边效果');
imwrite(uint8(im3),'tailored.jpg');