function writeToFolder(prefolder,folder,path,num)
I=imread(path);
img_path=strcat(prefolder,'\',folder,'\',num2str(num),'.jpg');
imwrite(I,img_path);%²»·Ö±àºÅÐ´


