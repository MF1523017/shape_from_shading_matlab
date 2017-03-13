function height_map = neighbor8_optimize(surface_normals,mask,roi)

% A_c,A_r是稀疏矩阵的行和列
% solve A*z=b;

surf_n3=surface_normals(:,:,3);
surf_n3(surf_n3==0)=1e-10;
fx = squeeze(surface_normals(:,:,1)./surf_n3);
fy = squeeze(surface_normals(:,:,2)./surf_n3);
% fx=fx(roi(2,1):roi(2,2),roi(1,1):roi(1,2));
% fy=fy(roi(2,1):roi(2,2),roi(1,1):roi(1,2));
imageHeight=roi(2,2)-roi(2,1)+1;
imageWidth=roi(1,2)-roi(1,1)+1;
%八邻域平均，2到最后一行
 [fx,fy]=smooth_8(fx,fy,imageWidth,imageHeight,mask);

A_c = zeros(8 * (imageHeight - 2) * (imageWidth - 2) + 1, 1);
A_r = zeros(8 * (imageHeight - 2) * (imageWidth - 2) + 1, 1);
A_v = zeros(8 * (imageHeight - 2) * (imageWidth - 2) + 1, 1);
b = zeros(4 * (imageHeight - 2) * (imageWidth - 2) + 1, 1);

% c : idx of constraint
c = 1;
A_c(c) = 1;
A_r(c) = 1;
A_v(c) = 1;
b(c) = 1;

for i = 2 : imageHeight
    for j = 2 : imageWidth - 1
        [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, j, -1, -1);
        [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, j, -1, 0);
        [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, j, -1, 1);
        [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, j, 0, -1);
    end
    %最后一列无右邻，单独处理
    [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, imageWidth, -1, -1);
    [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, imageWidth, -1, 0);
    [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, imageWidth, i, imageWidth, 0, -1);
end

A = sparse(A_r, A_c, A_v);

%             z=inv(A'*A)*A'*b';
z = A \ b;

% if norm(b)/norm(A*z-b)<3;
%     disp('random_from_middle method');
%     height_map=random_from_middle(fx,fy,imageHeight,imageWidth);
% else
    disp('neighbor8 method');
    height_map = reshape(z, imageWidth, imageHeight);
    height_map = height_map';
% end

end

function image_id = derive_image_id(i, j, width)
image_id = width * (i - 1) + j;
end

function [A_r, A_c, A_v, c, b] = prepare_constraint(A_r, A_c, A_v, b, c, fx, fy, width, i, j, di, dj)
A_c(c * 2) = derive_image_id(i, j, width);
A_r(c * 2) = c + 1;
A_v(c * 2) = 1;
A_c(c * 2 + 1) = derive_image_id(i + di, j + dj, width);
A_r(c * 2 + 1) = c + 1;
A_v(c * 2 + 1) = -1;
if (sign(di) > 0)
    b(c + 1) = sum(fy(i : i, j)) - sum(fy(i : i + di, j));
else
    b(c + 1) = sum(fy(i + di : i, j)) - sum(fy(i + di : i + di, j));
end

if (sign(dj) > 0)
    b(c + 1) = b(c + 1) + sum(fx(i, j : j)) - sum(fx(i, j : j + dj));
else
    b(c + 1) = b(c + 1) + sum(fx(i, j + dj : j)) - sum(fx(i, j + dj : j + dj));
end

c = c + 1;
end

function [fx,fy]=smooth_8(fx,fy,imageWidth,imageHeight,mask)
for i=2:imageHeight-1
    for j=2:imageWidth-1
       
        if mask(i,j)==1 
            sum_x4=fx(i-1,j)+fx(i+1,j)+fx(i,j-1)+fx(i,j+1);
            sum_y4=fy(i-1,j)+fy(i+1,j)+fy(i,j-1)+fy(i,j+1);
            if abs(sum_x4)<abs(fx(i,j)) || sign(sum_x4)~= sign(fx(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fx(i,j)=sum_x4/4;
            end
            if abs(sum_y4)<abs(fy(i,j)) || sign(sum_y4) ~= sign(fy(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fy(i,j)=sum_y4/4;
            end
        else
            fx(i,j)=0;
            fy(i,j)=0;
        end
    end
end
%第一行和最后一行，二邻域
for i=[1,imageHeight]
for j=2:imageWidth-1
    if mask(i,j)==1
        sum_x2=fx(i,j-1)+fx(i,j+1);
        sum_y2=fy(i,j-1)+fy(i,j+1);
         if (sign(sum_x2)<0 && fx(i,j)<sum_x2) || (sign(sum_x2)>0 && sum_x2>fx(i,j))|| sign(sum_x2)~=sign(fx(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fx(i,j)=sum_x2/2;
         end
         if (sign(sum_y2)<0 && fy(i,j)<sum_y2) || (sign(sum_y2)>0 && sum_y2>fy(i,j)) || sign(sum_y2)~=sign(fy(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fy(i,j)=sum_y2/2;
         end
    else
            fx(i,j)=0;
            fy(i,j)=0;
    end
    
end
end
for j=[1,imageWidth]
for i=2:imageHeight-1
    if mask(i,j)==1
        sum_x2=fx(i-1,j)+fx(i+1,j);
        sum_y2=fy(i-1,j)+fy(i+1,j);
         if (sign(sum_x2)<0 && fx(i,j)<sum_x2) || (sign(sum_x2)>0 && sum_x2>fx(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fx(i,j)=sum_x2/2;
         end
         if (sign(sum_y2)<0 && fy(i,j)<sum_y2) || (sign(sum_y2)>0 && sum_y2>fy(i,j))
%             if  (sum(fx(i-1,j-1:j+1))+sum(fx(i+1,j-1:j+1))+fx(i,j-1)+fx(i,j+1))<abs(fx(i,j))
                fy(i,j)=sum_y2/2;
         end
    else
            fx(i,j)=0;
            fy(i,j)=0;     
    end
    
end
end


end

