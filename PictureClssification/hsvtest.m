function [histhsv]=hsvtest(location,id)
flag=1;
img_num=size(location,1);
if(id==1)
    hsvLen=12;
    histhsv=zeros(img_num,hsvLen);
    temphsv=zeros(1,hsvLen);
    if img_num> 0 %������������ͼ��
     for j = 1:img_num %��һ��ȡͼ��
            image_name = location{j,2};% ͼ����
            I =imread(image_name);
            I1=rgb2gray(I);%�ҶȻ�ͼ��
            [r,c]=size(I1);
            ss=r*c;
            I2=rgb2hsv(I);%HSV��ͼ��
            %fprintf(' %d %s\n',j,image_name);% ��ʾ���ڴ����ͼ����  
            H=round(I2(:,:,1)*360);
            histhsv(flag,1)=(length(find(H<=360&H>=345))+length(find(H<15&H>=0)))/ss*100;
            for y=2:hsvLen
                temphsv(1,y)=length(find(H<15+(y-1)*30&H>=15+(y-2)*30))/ss*100;
                histhsv(flag,y)=histhsv(flag,y-1)+temphsv(1,y);
            end
            flag=flag+1;
     end
    end
else
    hsvLen=360;
    histhsv=zeros(img_num,hsvLen);
    temphsv=zeros(1,hsvLen);
    if img_num> 0 %������������ͼ��
     for j = 1:img_num %��һ��ȡͼ��
            image_name = location{j,2};% ͼ����
            I =imread(image_name);
            I1=rgb2gray(I);%�ҶȻ�ͼ��
            [r,c]=size(I1);
            ss=r*c;
            I2=rgb2hsv(I);%HSV��ͼ��
            %fprintf(' %d %s\n',j,image_name);% ��ʾ���ڴ����ͼ����  
            H=round(I2(:,:,1)*360);
            histhsv(flag,1)=(length(find(H==0))+length(find(H==360)))/ss*100;
            for y=2:hsvLen
                temphsv(1,y)=length(find(H==y-1))/ss*100;
                histhsv(flag,y)=histhsv(flag,y-1)+temphsv(1,y);
            end
            flag=flag+1;
     end
    end
end

