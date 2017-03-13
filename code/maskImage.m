function [mask,roi]=maskImage(time,imageCount)
%将每一幅图像的mask 找出来，然后进行或操作，得到最终的mask
img=imread(strcat('data/',time,'/pic/image1.jpg'));
img=rgb2gray(img);
[m,n]=size(img);
imgs=zeros(imageCount,m,n);
for k=1:imageCount
img=imread(strcat('data/',time,'/pic/image',int2str(k),'.jpg'));
img=rgb2gray(img);
for i =1:m
    for j=1:n
        %设定阈值
        if img(i,j)<50
            imgs(k,i,j)=0;
        else
            imgs(k,i,j)=1;
        end
    end
end
end
%或操作
img_m=imgs(1,:,:)|imgs(2,:,:);
for i=2:imageCount
    img_m=img_m|imgs(i,:,:);
end
img_m=squeeze(img_m);
%找到非零点的位置
[h,w]=find(img_m);
roi=[min(w),max(w);min(h),max(h)];
mask=img_m(min(h):max(h),min(w):max(w));
imshow(mask);
mask=double(mask);
mask=LabelMaskImage(mask);

imwrite(mask,strcat('data/',time,'/pic/maskImage.jpg'))
