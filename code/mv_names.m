%function mv_names
pic_name='data6';
for i=1:34
    if i<11
        movefile(strcat('data/',pic_name,'/pic/image (',int2str(i),').png'),strcat('data/',pic_name,'/pic/000',int2str(i-1),'-c1.jpg'));
    else
        movefile(strcat('data/',pic_name,'/pic/image (',int2str(i),').png'),strcat('data/',pic_name,'/pic/00',int2str(i-1),'-c1.jpg'));
    end
end