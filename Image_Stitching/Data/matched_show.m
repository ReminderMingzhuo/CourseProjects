% 创建平行图像，显示匹配特征点
im3 = appendimages(im1,im2);
figure('Position', [10 10 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: length(match)
  if (match(i) > 0)
    line([loc1(i,2) loc2(match(i),2)+cols1], ...
         [loc1(i,1) loc2(match(i),1)], 'Color', 'c');
    hold on
    plot(loc1(i,2), loc1(i,1),'ro')
    plot(loc2(match(i),2)+cols1, loc2(match(i),1),'ro')
    hold off
  end
end
hold off;
num = sum(match > 0);
fprintf('Found %d matches.\n', num);

%取出匹配特征点pt1 和 pt2  
ptlen=sum(match>0);
pt1=zeros(ptlen,2);
pt2=zeros(ptlen,2);
counter=1;
for i = 1: size(des1,1)
     if (match(i) > 0)
        pt1(counter,:)=loc1(i,2:-1:1);
        pt2(counter,:)=loc2(match(i),2:-1:1);
        counter=counter+1;
     end
end