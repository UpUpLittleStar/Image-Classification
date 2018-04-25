%%%%%%%%%%%%%%%%%%��ȡLBP������HSV����%%%%%%%%%%%%%%%%%%%%%%%%%
function [histlbp,histhsv]=lbptest(location)
lbpLen=256;
hsvLen=12;
flag=1;
img_num=size(location,1);
histlbp=zeros(img_num,lbpLen);
histhsv=zeros(img_num,hsvLen);
templbp=zeros(1,lbpLen);
temphsv=zeros(1,hsvLen);
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
if img_num> 0 %������������ͼ��
     for j = 1:img_num %��һ��ȡͼ��
            image_name = location{j,2};% ͼ����
            I =imread(image_name);
            I1=rgb2gray(I);%�ҶȻ�ͼ��
            [r,c]=size(I1);
            ss=r*c;
            I2=rgb2hsv(I);%HSV��ͼ��
            graylbp=LBP(I1,SP,0,'i'); 
            [r,c]=size(graylbp);
            s2=r*c;
            %fprintf(' %d %s\n',j,image_name);% ��ʾ���ڴ����ͼ����  
            H=round(I2(:,:,1)*360);
            histlbp(flag,1)=length(find(graylbp==0))/s2*100;
            for x=2:lbpLen
                templbp(1,x)=length(find(graylbp==(x-1)))/s2*100;
                histlbp(flag,x)=histlbp(flag,x-1)+templbp(1,x);
            end
            histhsv(flag,1)=(length(find(H<=360&H>=345))+length(find(H<15&H>=0)))/ss*100;
            for y=2:hsvLen 
                temphsv(1,y)=length(find(H<15+(y-1)*30&H>=15+(y-2)*30))/ss*100;
                histhsv(flag,y)=histhsv(flag,y-1)+temphsv(1,y); 
            end
            flag=flag+1;
     end
end

