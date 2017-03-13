 function [  ] = SaveObjMesh( filename, HeightImage, roi)
%SAVEOBJMESH Summary of this function goes here
%   Detailed explanation goes here

% SAVEOBJMESH Save a x,y,z mesh as a Wavefront/Alias Obj file
% SAVEOBJMESH(fname,x,y,z,nx,ny,nz)
%     Saves the mesh to the file named in the string fname
%     x,y,z are equally sized matrices with coordinates.
%     nx,ny,nz are normal directions (optional)

%if nargin<1
%     filename='test.obj';
%     HeightImage= importdata('RefHeightMat.mat');
%     MaskImage=importdata('RefMaskImage.mat');
   % print 'nargin<1';
% end

%[imageWidth, imageHeight] = size(HeightImage);
%MaskImage=imread('data/second/pic/maskImage.jpg');
imageHeight=roi(2,2)-roi(2,1)+1;
imageWidth=roi(1,2)-roi(1,1)+1;


n = zeros(imageHeight, imageWidth);

fid = fopen(filename,'w');
nn = 0;
for i = 1:imageHeight
    for j = 1:imageWidth
        %if MaskImage(i,j) > 0.5
            nn = nn+1;
            n(i,j) = nn; 
            fprintf(fid, 'v %f %f %f\n', i, j, HeightImage(i,j)); 
       % end
    end
end
fprintf(fid,'g mesh\n');

for i = 1:imageHeight-1
    for j = 1:imageWidth-1
        %if MaskImage(i,j) > 0.5
            fprintf(fid,'f %d %d %d\n', n(i,j), n(i+1,j), n(i,j+1));
            fprintf(fid,'f %d %d %d\n', n(i+1,j+1), n(i,j+1), n(i+1,j));
       % end
    end
end

fprintf(fid,'g\n\n');
fclose(fid);

 end
