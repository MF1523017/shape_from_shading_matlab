%���ļ����ڻ��ROI ͼ��
clc;
imgcount=5;
imageLocation='Images/pic/';
imageName='image';
imageExtension='.jpg';
for i=1:imgcount
    image=strcat(imageLocation, imageName, int2str(i), imageExtension);
    img=imread(image);
    img=img(310:1069,916:1173,:);
    imwrite(img,image);
end