function [pt1,pt2] = match(im1,des1,loc1,im2,des2,loc2)
%% 查找匹配特征点
distRatio = 0.3;   % 设置特征距离阈值, 阈值越小越严格
des2t = des2';                          
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        
   [vals,indx] = sort(acos(dotprods)); %
   if (vals(1) < distRatio * vals(2))
      matched(i) = indx(1);
   else
      matched(i) = 0;
   end
end
% match = matchFeatures(des1,des2,  'MatchThreshold', 20,'MaxRatio',0.1 );

% 创建平行图像，显示匹配特征点
rows1 = size(im1,1);
rows2 = size(im2,1);
if (rows1 < rows2)
     im1(rows2,1) = 0;%将两张图维度调至一致
else
     im2(rows1,1) = 0;
end
im3 = [im1 im2]; %左右拼接

figure('Position', [10 10 size(im3,2) size(im3,1)]);
title('特征点匹配图');
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: length(matched)
  if (matched(i) > 0)
    line([loc1(i,2) loc2(matched(i),2)+cols1], ...
         [loc1(i,1) loc2(matched(i),1)], 'Color', 'b');
    hold on
    plot(loc1(i,2), loc1(i,1),'co')
    plot(loc2(matched(i),2)+cols1, loc2(matched(i),1),'co')
    hold off
  end
end
hold off;
num = sum(matched > 0);
fprintf('Found %d matches.\n', num);

%取出匹配特征点pt1 和 pt2  
ptlen=sum(matched>0);
pt1=zeros(ptlen,2);
pt2=zeros(ptlen,2);
counter=1;
for i = 1: size(des1,1)
     if (matched(i) > 0)
        pt1(counter,:)=loc1(i,2:-1:1);
        pt2(counter,:)=loc2(matched(i),2:-1:1);
        counter=counter+1;
     end
end