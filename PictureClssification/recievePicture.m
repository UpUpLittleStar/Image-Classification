%%%%%%%%%%%%%%%%%%%��ȡ���е�ͼ�������%%%%%%%%%%%%%%%%%%%%%%%%
function location=recievePicture(file_path)
img_path_list=dir(file_path);%��ȡ���е����ļ���
img_num = length(img_path_list);%��ȡͼ��������
location=cell(img_num-2,2);
if img_num-2 > 0 %������������ͼ��
     for j = 3:img_num %��һ��ȡͼ��
            image_name = img_path_list(j).name;% ͼ����
            location{j-2,1}=j-2;
            location{j-2,2}=strcat(file_path,image_name);
     end
end