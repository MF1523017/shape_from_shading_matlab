function [ LabeledMaskImage ] = LabelMaskImage( MaskImage )
%LABELMASKIMAGE Summary of this function goes here
%   Detailed explanation goes here

    function[flag] = IsInternal(i, j, MaskImage)
        if(MaskImage(i-1, j-1) > 0.5 && MaskImage(i, j-1) > 0.5 && MaskImage(i+1, j-1) > 0.5 && MaskImage(i-1, j) > 0.5 && MaskImage(i+1, j) > 0.5 && MaskImage(i-1, j+1) > 0.5 && MaskImage(i, j+1) > 0.5 && MaskImage(i+1, j+1) > 0.5)
        % wrong but work: if MaskImage(i-1,j-1) > 0.5 && MaskImage(i-1,j) > 0.5 && MaskImage(i+1,j) > 0.5 && MaskImage(i+1,j) > 0.5
        % right but not work: if MaskImage(i-1,j) > 0.5 && MaskImage(i,j-1) > 0.5 && MaskImage(i,j+1) > 0.5 && MaskImage(i+1,j) > 0.5
            flag = 1;
        else
            flag = 0;
        end
    end

[imageWidth, imageHeight] = size(MaskImage);

LabeledMaskImage = MaskImage;

for i = 2:imageWidth-1
    for j = 2:imageHeight-1
        if LabeledMaskImage(i, j) == 1 && IsInternal(i, j, MaskImage) == 0
            LabeledMaskImage(i, j) = 2;
        end
    end
end

end

