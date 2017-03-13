%clear all;
%close all;
time='forth';
im=imread(strcat('data/',time,'/pic/forth.jpg'));
[imageHeight,imageWidth,n]=size(im);

xyz=load(strcat('data/',time,'/xyz.txt'));
final_p=importdata('mat/depth_results.mat');
K=final_p.final_calib.rK{1};
kc=final_p.final_calib.rkc{1};
R=final_p.final_calib.dR;
t=final_p.final_calib.dt;
depth=xyz(:,3);
xyz=xyz';
min_depth=min(depth);
p=project_points_k(1000*xyz,K,kc,R,t);
p_size=size(p);
p=floor(p);
p(1,p(1,:)>imageWidth)=imageWidth;
p(2,p(2,:)>imageHeight)=imageHeight;
p(1,p(1,:)<1)=1;
p(2,p(2,:)<1)=1;
for i=1:p_size(2)
    im(p(2,i),p(1,i))=255;
end

imshow(im);



% -0.747880;0.736328;-1.275391
% 0.748047;0.689453;-1.196391
% -0.746399;-0.748047;-1.392578
% 0.747966;-0.701172;-1.201172
% P=importdata('IntrinsicMatrix.mat');
% P=load('test_intrinsic.txt');
% uv=xyz*P';
% depth=xyz(:,3);
% min_depth=min(depth);
% U=floor(uv(:,1)./uv(:,3));
% V=floor(uv(:,2)./uv(:,3));
% U(U<1)=1;
% U(U>imageWidth)=imageWidth;
% V(V<1)=1;
% V(V>imageHeight)=imageHeight;
% % UV=[U V];
% % UV_Depth=[UV -1000*depth];
% p_size=size(U);
% I=zeros(max(V),max(U));
% for i=1:p_size(1)
%     
% %     V(i)=V(i)+15;
% %     U(i)=U(i)+85;
%     I(V(i),U(i))=1000*(depth(i)-min_depth);
%     im(V(i),U(i))=100;
% end
% imshow(im);
% [x,y] = ginput(3);
% 
