function  height_map = get_surface(surface_normals, imageHeight,imageWidth, method)
% surface_normals: 3 x num_pixels array of unit surface normals
% image_size: [h, w] of output height map/image
% height_map: height map of object  h*w

    TIMES = 100;
%% <<< fill in your code below >>>
    height_map = zeros(imageHeight,imageWidth);
    fx = zeros(imageHeight,imageWidth);
    fy = zeros(imageHeight,imageWidth);
    surf_n3=surface_normals(:,:,3);
    surf_n3(surf_n3==0)=1e-10;
    fx = squeeze(surface_normals(:,:,1)./surf_n3);
    fy = squeeze(surface_normals(:,:,2)./surf_n3);
    switch method
        case 'column'     
            cum_fx = cumsum(fx, 2);
            cum_fy = cumsum(fy, 1);
            height_map = cum_fx + repmat(cum_fy(:,1), 1, imageWidth);
        case 'row'
            cum_fx = cumsum(fx, 2);
            cum_fy = cumsum(fy, 1);
            height_map = cum_fy + repmat(cum_fx(1,:), imageHeight, 1);
        case 'average'
            cum_fx = cumsum(fx, 2);
            cum_fy = cumsum(fy, 1);
            height_map = cum_fx + repmat(cum_fy(:,1), 1, imageWidth) + cum_fy + repmat(cum_fx(1,:), imageHeight, 1);
            height_map = height_map/2;
        case 'neighbor'
            img_size=imageHeight*imageWidth;
%             A=zeros(4*img_size,img_size);
            A_1=zeros(8*(imageHeight-2)*(imageWidth-2),1);
            A_2=zeros(8*(imageHeight-2)*(imageWidth-2),1);
%             b=zeros(4*img_size,1);
%             fx=reshape(fx,1,img_size);
%             fy=reshape(fy,1,img_size);
            k=1;
            m=1;
            n=0;
            l=0;
            for i=2:imageHeight-1
                for j=2:imageWidth-1
%                     A(imageWidth*(i-1)+j,imageWidth*(i-1)+j)=1;
%                     A(imageWidth*(i-2)+j,imageWidth*(i-1)+j)=-1;
%                     A(imageWidth*(i-1)+j-1,imageWidth*(i-1)+j)=-1;
%                     A(imageWidth*(i-1)+j+1,imageWidth*(i-1)+j)=-1;
%                     A(imageWidth*i+j,imageWidth*(i-1)+j)=-1;
                    A_1(k)=imageWidth*(i-1)+j;
                    A_1(k+1)=imageWidth*(i-2)+j;
                    A_1(k+2)=imageWidth*(i-1)+j;
                    A_1(k+3)=imageWidth*(i-1)+j-1;
                    A_1(k+4)=imageWidth*(i-1)+j;
                    A_1(k+5)=imageWidth*(i-1)+j+1;
                    A_1(k+6)=imageWidth*(i-1)+j;
                    A_1(k+7)=imageWidth*i+j;
                    k=k+8;
                    A_2(m)=imageWidth*(i-1)+j+n;
                    A_2(m+1)=imageWidth*(i-1)+j+n;
                    A_2(m+2)=imageWidth*(i-1)+j+n+1;
                    A_2(m+3)=imageWidth*(i-1)+j+n+1;
                    A_2(m+4)=imageWidth*(i-1)+j+n+2;
                    A_2(m+5)=imageWidth*(i-1)+j+n+2;
                    A_2(m+6)=imageWidth*(i-1)+j+n+3;
                    A_2(m+7)=imageWidth*(i-1)+j+n+3;
                    n=n+3;
                    m=m+8;
                    b(imageWidth*(i-1)+j+l)=sum(fx(i-1:i,j));
                    b(imageWidth*(i-1)+j+l+1)=sum(fy(i,j-1:j));
                    b(imageWidth*(i-1)+j+l+2)=-sum(fy(i,j:j+1));
                    b(imageWidth*(i-1)+j+l+3)=-sum(fx(i:i+1,j));
                    l=l+3;
                end
            end
            
            s=[1,-1,1,-1,1,-1,1,-1];
            A=sparse(A_2,A_1,repmat(s,1,(imageHeight-2)*(imageWidth-2)));
            %z=inv(A'*A)*A'*b';
            z=A\b';
            
            height_map=reshape(z,imageHeight,imageWidth);
      case 'neighbor8'
            height_map = neighbor8_optimize(fx, fy, imageHeight, imageWidth);
%             img_size=imageHeight*imageWidth;
% %             A=zeros(4*img_size,img_size);
%             A_1=zeros(16*(imageHeight-2)*(imageWidth-2),1);
%             A_2=zeros(16*(imageHeight-2)*(imageWidth-2),1);
%              %b=zeros(4*img_size,1);
% %             fx=reshape(fx,1,img_size);
% %             fy=reshape(fy,1,img_size);
%             k=2;
%             m=2;
%             n=0;
%             l=0;
%             A_1(1)=1;
%             A_2(1)=1;
%             b(1)=1;
%             for i=2:imageHeight-1
%                 for j=2:imageWidth-1
% %                     A(imageWidth*(i-1)+j,imageWidth*(i-1)+j)=1;
% %                     A(imageWidth*(i-2)+j,imageWidth*(i-1)+j)=-1;
% %                     A(imageWidth*(i-1)+j-1,imageWidth*(i-1)+j)=-1;
% %                     A(imageWidth*(i-1)+j+1,imageWidth*(i-1)+j)=-1;
% %                     A(imageWidth*i+j,imageWidth*(i-1)+j)=-1;
%                     A_1(k)=imageWidth*(i-1)+j;
%                     A_1(k+1)=imageWidth*(i-2)+j;
%                     A_1(k+2)=imageWidth*(i-1)+j;
%                     A_1(k+3)=imageWidth*(i-1)+j-1;
%                     A_1(k+4)=imageWidth*(i-1)+j;
%                     A_1(k+5)=imageWidth*(i-1)+j+1;
%                     A_1(k+6)=imageWidth*(i-1)+j;
%                     A_1(k+7)=imageWidth*i+j;
%                     A_1(k+8)=imageWidth*(i-1)+j;
%                     A_1(k+9)=imageWidth*(i-2)+j-1;
%                     A_1(k+10)=imageWidth*(i-1)+j;
%                     A_1(k+11)=imageWidth*(i-2)+j+1;
%                     A_1(k+12)=imageWidth*(i-1)+j;
%                     A_1(k+13)=imageWidth*i+j-1;
%                     A_1(k+14)=imageWidth*(i-1)+j;
%                     A_1(k+15)=imageWidth*i+j+1;
%                     
%                     k=k+16;
%                     A_2(m)=imageWidth*(i-1)+j+n;
%                     A_2(m+1)=imageWidth*(i-1)+j+n;
%                     A_2(m+2)=imageWidth*(i-1)+j+n+1;
%                     A_2(m+3)=imageWidth*(i-1)+j+n+1;
%                     A_2(m+4)=imageWidth*(i-1)+j+n+2;
%                     A_2(m+5)=imageWidth*(i-1)+j+n+2;
%                     A_2(m+6)=imageWidth*(i-1)+j+n+3;
%                     A_2(m+7)=imageWidth*(i-1)+j+n+3;
%                     A_2(m+8)=imageWidth*(i-1)+j+n+4;
%                     A_2(m+9)=imageWidth*(i-1)+j+n+4;
%                     A_2(m+10)=imageWidth*(i-1)+j+n+5;
%                     A_2(m+11)=imageWidth*(i-1)+j+n+5;
%                     A_2(m+12)=imageWidth*(i-1)+j+n+6;
%                     A_2(m+13)=imageWidth*(i-1)+j+n+6;
%                     A_2(m+14)=imageWidth*(i-1)+j+n+7;
%                     A_2(m+15)=imageWidth*(i-1)+j+n+7;
%                     n=n+7;
%                     m=m+16;
%                     b(imageWidth*(i-1)+j+l)=sum(fx(i-1:i,j));
%                     b(imageWidth*(i-1)+j+l+1)=sum(fy(i,j-1:j));
%                     b(imageWidth*(i-1)+j+l+2)=-sum(fy(i,j:j+1));
%                     b(imageWidth*(i-1)+j+l+3)=-sum(fx(i:i+1,j));
%                     b(imageWidth*(i-1)+j+l+4)=sum(fx(i-1:i,j))+sum(fy(i,j-1:j));
%                     b(imageWidth*(i-1)+j+l+5)=sum(fx(i-1:i,j))-sum(fy(i,j:j+1));
%                     b(imageWidth*(i-1)+j+l+6)=-sum(fx(i:i+1,j))+sum(fy(i,j-1:j));
%                     b(imageWidth*(i-1)+j+l+7)=-sum(fx(i:i+1,j))-sum(fy(i,j:j+1));
%                     l=l+7;
%                 end
%             end
%             
%             s=[1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1];
%             A=sparse(A_2,A_1,[1 repmat(s,1,(imageHeight-2)*(imageWidth-2))]);
%  %           z=inv(A'*A)*A'*b';
%             
%             z=A\b';
%             %z=[0;z];
%             height_map=reshape(z,imageWidth,imageHeight);
%             height_map=height_map';
        case 'random'
            for times = 1:TIMES
                for i = 1:imageHeight
                    for j = 1:imageWidth
                        k = 1;
                        l = 1;
                        while k <= i && l <=j 
                            if mod(round(10*rand()), 2) == 0 %right
                                height_map(i, j) = height_map(i, j) + fx(k, l);
                                l = l + 1;
                            else %down
                                height_map(i, j) = height_map(i, j) + fy(k, l);
                                k = k + 1;
                            end
                        end
                        while k<=i
                            height_map(i, j) = height_map(i, j) + fy(k, l-1);
                            k = k + 1;
                        end
                        while l<=j
                            height_map(i, j) = height_map(i, j) + fx(k-1, l);
                            l = l + 1;
                        end
                    end
                end
            end
            height_map = height_map/TIMES;
        case 'random_from_middle'
            for times = 1:TIMES
                for i = 1:floor(imageHeight/2)
                    for j = 1:floor(imageWidth/2)
                        k = floor(imageHeight/2);
                        l = floor(imageWidth/2);
                        while k >= i && l >= j 
                            if mod(round(10*rand()), 2) == 0 %left
                                height_map(i, j) = height_map(i, j) - fx(k, l);
                                l = l - 1;
                            else %top
                                height_map(i, j) = height_map(i, j) - fy(k, l);
                                k = k - 1;
                            end
                        end
                        while k>=i
                            height_map(i, j) = height_map(i, j) - fy(k, l+1);
                            k = k - 1;
                        end
                        while l>=j
                            height_map(i, j) = height_map(i, j) - fx(k+1, l);
                            l = l - 1;
                        end
                    end
                end
                for i = 1:floor(imageHeight/2)
                    for j = floor(imageWidth/2)+1:imageWidth
                        k = floor(imageHeight/2);
                        l = floor(imageWidth/2);
                        while k >= i && l <=j 
                            if mod(round(10*rand()), 2) == 0 
                                height_map(i, j) = height_map(i, j) + fx(k, l);
                                l = l + 1;
                            else 
                                height_map(i, j) = height_map(i, j) - fy(k, l);
                                k = k - 1;
                            end
                        end
                        while k>=i
                            height_map(i, j) = height_map(i, j) - fy(k, l-1);
                            k = k - 1;
                        end
                        while l<=j
                            height_map(i, j) = height_map(i, j) + fx(k+1, l);
                            l = l + 1;
                        end
                    end
                end
                for i = floor(imageHeight/2)+1:imageHeight
                    for j = 1:floor(imageWidth/2)
                        k = floor(imageHeight/2);
                        l = floor(imageWidth/2);
                        while k <= i && l >=j 
                            if mod(round(10*rand()), 2) == 0 %right
                                height_map(i, j) = height_map(i, j) - fx(k, l);
                                l = l - 1;
                            else %down
                                height_map(i, j) = height_map(i, j) + fy(k, l);
                                k = k + 1;
                            end
                        end
                        while k<=i
                            height_map(i, j) = height_map(i, j) + fy(k, l+1);
                            k = k + 1;
                        end
                        while l>=j
                            height_map(i, j) = height_map(i, j) - fx(k-1, l);
                            l = l - 1;
                        end
                    end
                end
                 for i = floor(imageHeight/2)+1:imageHeight
                    for j =floor(imageWidth/2)+1:imageWidth
                        k = floor(imageHeight/2);
                        l = floor(imageWidth/2);
                        while k <= i && l <=j 
                            if mod(round(10*rand()), 2) == 0 %right
                                height_map(i, j) = height_map(i, j) + fx(k, l);
                                l = l + 1;
                            else %down
                                height_map(i, j) = height_map(i, j) + fy(k, l);
                                k = k + 1;
                            end
                        end
                        while k<=i
                            height_map(i, j) = height_map(i, j) + fy(k, l-1);
                            k = k + 1;
                        end
                        while l<=j
                            height_map(i, j) = height_map(i, j) + fx(k-1, l);
                            l = l + 1;
                        end
                    end
                end
            end
            height_map = height_map/TIMES;
    end

end

