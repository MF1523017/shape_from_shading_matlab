function [mask,roi]=maskImage(time,imageCount)
%��ÿһ��ͼ���mask �ҳ�����Ȼ����л�������õ����յ�mask
img=imread(strcat('data/',time,'/pic/image1.jpg'));
img=rgb2gray(img);
[m,n]=size(img);
imgs=zeros(imageCount,m,n);
for k=1:imageCount
img=imread(strcat('data/',time,'/pic/image',int2str(k),'.jpg'));
img=rgb2gray(img);
for i =1:m
    for j=1:n
        %�趨��ֵ
        if img(i,j)<50
            imgs(k,i,j)=0;
        else
            imgs(k,i,j)=1;
        end
    end
end
end
%�����
img_m=imgs(1,:,:)|imgs(2,:,:);
for i=2:imageCount
    img_m=img_m|imgs(i,:,:);
end
img_m=squeeze(img_m);
%�ҵ�������λ��
[h,w]=find(img_m);
roi=[min(w),max(w);min(h),max(h)];
mask=img_m(min(h):max(h),min(w):max(w));
imshow(mask);
mask=double(mask);
mask=LabelMaskImage(mask);

imwrite(mask,strcat('data/',time,'/pic/maskImage.jpg'))
