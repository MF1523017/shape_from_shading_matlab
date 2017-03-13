% 选取图像上面的点和三维空间中的点，构建齐次方程求解方程

clear all;
close all;
time='fifth';
im=imread(strcat('data/',time,'/pic/image1.jpg'));
[imageHeight,imageWidth,n]=size(im);
% K=importdata('IntrinsicMatrix.mat');
imshow(im);
% [x,y] = ginput(6);
% 
% xy=[x y ones(6,1)];
xy=importdata(strcat('data/',time,'/point_2d.mat'));
%T 归一化点 
T=[2.0/(imageHeight+imageWidth) 0 -imageWidth*1.0/(imageHeight+imageWidth);
    0 2.0/(imageHeight+imageWidth) -imageHeight*1.0/(imageHeight+imageWidth);
    0 0 1];
xy=xy*T';
x=xy(:,1);
y=xy(:,2);
%load 三维空间中的点
point_3d=load(strcat('data/',time,'/point_3d.txt'));
%齐次坐标
point_3d=[point_3d ones(6,1)];
A=zeros(12,12);
for i =1:6
A(2*i-1,1:4)=-point_3d(i,:);
A(2*i-1,9:12)=x(i)*point_3d(i,:);
A(2*i,5:8)=-point_3d(i,:);
A(2*i,9:12)=y(i)*point_3d(i,:);
end
%最小二乘求解SVD
[u,s,v]=svd(A);
p=v(:,12);
M=reshape(p,4,3)';
xyz=load(strcat('data/',time,'/xyz.txt'));

[p_number m]=size(xyz);
xyz=[xyz ones(p_number,1)];
%  P=importdata('ProjectMatrix.mat');
% P=importdata('IntrinsicMatrix.mat');
M=T^-1*M;
uv=xyz*M';
depth=xyz(:,3);
min_depth=min(depth);
U=floor(uv(:,1)./uv(:,3));
V=floor(uv(:,2)./uv(:,3));
U(U<1)=1;
U(U>imageWidth)=imageWidth;
V(V<1)=1;
V(V>imageHeight)=imageHeight;
% UV=[U V];
% UV_Depth=[UV -1000*depth];
% p_size=size(U);
I=zeros(max(V),max(U));
for i=1:p_number
    
    V(i)=V(i);
    U(i)=U(i);
    I(V(i),U(i))=1000*(depth(i)-min_depth);
    im(V(i),U(i))=255;
end
imshow(im);



