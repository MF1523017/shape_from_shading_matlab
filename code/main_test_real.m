clc;
close all;
clear all;
lights=[10.6 -10.6 40;
    15 0 40;
    10.6 10.6 40;
    0 15 40;
    -10.6 10.6 40;
    -15 0 40;
    -10.6 -10.6 40];

%imageLocation = 'Images\six_pyramid_low_s\';
%imageLocation = 'Images\six_pyramid_s\';
% imageLocation = 'Images\six_pyramid_r1\';
 imageLocation = 'Images\six_pyramid_r2\';
% imageLocation = 'Images\mouse3\';
imageExtension = '.jpg';
%imageName = 'six_pyramid_low_s';
% imageName = 'six_pyramid_s';
% imageName = 'six_pyramid_r1';
 imageName = 'six_pyramid_r2';
% imageName = 'mouse3';

imageCount = 7;
%imageHeight = 191;imageWidth = 191;
% imageHeight = 191;imageWidth = 191;
% imageHeight = 450;imageWidth = 491;
 imageHeight = 451;imageWidth = 495;
% imageHeight =291 ;imageWidth = 231;
% imageHeight =97 ;imageWidth = 77;
tic;
% imageHeight =1080 ;imageWidth = 1920;
[mask,roi]=maskImage(time,imageCount);

%lights=importdata('lights.mat');
% lights=RecoverLight(time,imageLocation, imageExtension, imageName, imageCount, imageHeight, imageWidth, false);
toc;
tic;
[albedo_image, surface_normals] = shapeFromShading_real(lights, imageLocation,imageExtension,...
    imageName, imageCount, roi, false);
toc;

% shape=get_surface(surface_normals, imageHeight,imageWidth, method);

tic;
shape=neighbor8_optimize(surface_normals,mask,roi);
toc;
display_output(albedo_image,shape);
plot_surface_normals(surface_normals);
SaveObjMesh(strcat('obj/',imageName,'-_nerghbor8.obj'),-shape,roi);

% img_size=size(shape);
% xyz=zeros(img_size(1)*img_size(2),3);
% n=reshape(brightness,img_size(1)*img_size(2),3);
% for i=1:img_size(1)
%     for j=1:img_size(2)
%         xyz(img_size(1)*(j-1)+i,:)=[j i shape(i,j)];
%     end
% end
% 
% writeOBJ(strcat('obj/',imageName,'.obj'),xyz,false,false,false,n,false);





