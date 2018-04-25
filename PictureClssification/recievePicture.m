%%%%%%%%%%%%%%%%%%%读取所有的图像的名字%%%%%%%%%%%%%%%%%%%%%%%%
function location=recievePicture(file_path)
img_path_list=dir(file_path);%获取所有的子文件名
img_num = length(img_path_list);%获取图像总数量
location=cell(img_num-2,2);
if img_num-2 > 0 %有满足条件的图像
     for j = 3:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            location{j-2,1}=j-2;
            location{j-2,2}=strcat(file_path,image_name);
     end
end