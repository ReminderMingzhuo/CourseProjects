function timg = tailor(img)
%��������
im=imread(img);
imsize=size(im);
%�������Ҷ˺ڱ߽���
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
%������Ͷ˺ڱ߽���
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
%ͼ��ü�����ʾ
timg = imcrop(im,[1 1 n0-1 m0-1]);
figure;
imshow(uint8(timg));
title('ȥ���ڱ�Ч��');
imwrite(uint8(im3),'tailored.jpg');