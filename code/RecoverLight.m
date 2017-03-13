%clear all;
function Lights=RecoverLight(time,imageLocation, imageExtension, imageName, imageCount, imageHeight, imageWidth, isGrayScale)
Lights=zeros(imageCount,3);
%time='first';
im = imread(strcat(imageLocation, imageName, '3', imageExtension));
xyz=load(strcat('data/',time,'/xyz.txt'));
%mask=imread(strcat('data/',time,'/pic/maskImage.jpg'));
P=importdata('mat/IntrinsicMatrix.mat');
uv=xyz*P';
depth=xyz(:,3);
min_depth=min(depth);
U=floor(uv(:,1)./depth);
V=floor(uv(:,2)./depth);
U(U<1)=1;
U(U>imageWidth-60)=imageWidth-60;
V(V<1)=1;
V(V>imageHeight-50)=imageHeight-50;
% UV=[U V];
% UV_Depth=[UV -1000*depth];
p_size=size(U);
I=zeros(max(V),max(U));
for i=1:p_size(1)
    
    V(i)=V(i)+50;
    U(i)=U(i)+60;
    I(V(i),U(i))=1000*(depth(i)-min_depth);
    im(V(i),U(i))=255;
end
figure;
imshow(im);

% m = imageHeight;
% n = imageWidth;
imgs = zeros(imageHeight,imageWidth,imageCount);
for i=1:imageCount
    img = imread(strcat(imageLocation, imageName, int2str(i), imageExtension));
    if (isGrayScale)
        imgs(:,:,i) = img;
    else
        imgs(:,:,i) = rgb2gray(img);
    end    
end
% im=imread(strcat('data/',time,'/pic/image1.jpg'));
% img=rgb2gray(im);
% img_size=size(img);
k=1;
for i =2:max(V)-1
    for j=2:max(U)-1
        if I(i,j)>0 && I(i-1,j)>0 && I(i,j-1)>0 %&& mask(i,j)==255
            N(k,:)=[I(i,j)-I(i,j-1) I(i,j)-I(i-1,j) 1];
            nrm=norm(N(k,:));
            N(k,:)=N(k,:)/nrm;
%             b(k,n)=imgs(i,j,n);
            k=k+1;
        end
    end
end


for n=1:imageCount

k=1;
for i =2:max(V)-1
    for j=2:max(U)-1
        if I(i,j)>0 && I(i-1,j)>0 && I(i,j-1)>0 %&& mask(i,j)==255
%             N(k,:,n)=[I(i,j)-I(i,j-1) I(i,j)-I(i-1,j) 1];
            b(k,n)=imgs(i,j,n);
            k=k+1;
        end
    end
end
Lights(n,:)=(N\double(b(:,n)))';
end


end
% S=n\double(b');


        
% for i=2:max(V)-1
%     for j=2:max(U)-1
%         if I(i,j)==0
%             I(i,j)=1/8*(I(i-1,j-1)+I(i-1,j)+I(i-1,j+1)+I(i,j-1)+I(i,j+1)+I(i+1,j-1)+I(i+1,j)+I(i+1,j+1));
%         end
%     end
% end

% SaveObjMesh(strcat('obj/',time,'.obj'),I,max(V),max(U));
% writeOBJ(strcat('obj/',time,'_xyz.obj'),UV_Depth,false,false,false,false,false);