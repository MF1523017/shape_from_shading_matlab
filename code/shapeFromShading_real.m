function [albedo_image, surface_normals] = shapeFromShading_real(lights, imageLocation, imageExtension, imageName, imageCount, roi, isGrayScale )
% shape from shading using multible images with their light source
imageHeight=roi(2,2)-roi(2,1)+1;
imageWidth=roi(1,2)-roi(1,1)+1;
m = imageHeight;
n = imageWidth;
%S = lights;

% load images
imgs = zeros(m,n,imageCount);
for i=1:imageCount
    img = imread(strcat(imageLocation, imageName, int2str(i), imageExtension));
    
    if (isGrayScale)
        img=img(roi(2,1):roi(2,2),roi(1,1):roi(1,2));
        img=medfilt2(img);
        imgs(:,:,i) = img;
    else
        img=rgb2gray(img);
        img=img(roi(2,1):roi(2,2),roi(1,1):roi(1,2));
        img=medfilt2(img);
        imgs(:,:,i) = img;
    end    
end

% normalize lights
for i=1:size(lights,1)
    light = lights(i,:);
    lights(i,:) = light/norm(light);
end
img_size=m*n;

I_matrix = reshape(imgs(:,:,1), 1, img_size);
for i = 2:imageCount
    I_matrix = cat(1, I_matrix, reshape(imgs(:,:,i), 1, img_size));
end

g = lights\I_matrix;
g = reshape(g, 3, imageHeight,imageWidth);

surface_normals = zeros(imageHeight, imageWidth, 3);

current_sum = bsxfun(@hypot, g(1,:,:), g(2,:,:));
current_sum = bsxfun(@hypot, current_sum, g(3,:,:));
albedo_image = squeeze(current_sum);
A=albedo_image;
A(A==0)=1e-10;
surface_normals(:, :, 1) = bsxfun(@rdivide, squeeze(g(1,:,:)), A); 
surface_normals(:, :, 2) = bsxfun(@rdivide, squeeze(g(2,:,:)), A); 
surface_normals(:, :, 3) = bsxfun(@rdivide, squeeze(g(3,:,:)), A); 



end




