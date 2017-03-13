clc;
close all;
clear all;

time='ninth';
imageLocation = strcat('data\',time,'\pic\');
imageExtension = '.jpg';

 imageName = 'image';

lights=load(strcat('data\',time,'\lights.txt'));
imageCount = 6;
tic;

[mask,roi]=maskImage(time,imageCount);

%lights=importdata('lights.mat');
% lights=RecoverLight(time,imageLocation, imageExtension, imageName, imageCount, imageHeight, imageWidth, false);
toc;
tic;
[albedo_image, surface_normals] = shapeFromShading_real(lights, imageLocation,imageExtension,...
    imageName, imageCount, roi, false);
toc;

tic;
shape=neighbor8_optimize(surface_normals,mask,roi);
toc;
display_output(albedo_image,shape);
plot_surface_normals(surface_normals);
tic;
SaveObjMesh(strcat('data\',time,'\','neighbor8.obj'),-shape,roi);
toc;
