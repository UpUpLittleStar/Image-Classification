%%%%%%%%%%%%%������%%%%%%%%%%%%%%%%
file_path =  'picture\';% ͼ���ļ���·��
location=recievePicture(file_path);
lbpLen=256;
hsvLen=12;
featureLen=lbpLen+hsvLen;
% [A,B]=lbptest(location);
% A=[A,B];
% xlswrite('feature.xlsx',A);
A=xlsread('feature.xlsx');
S=distanceCount(A,lbpLen);%���ƶȾ���
idx=AP(S);
N=length(idx);%�������ܳ���
[type,precenter,length_type,minnumber,stdvar,mindistance]=CountCenter(idx,A,lbpLen);%�����ķ�����,�������ĵ�������������ܸ���
stdvarmean=mean(stdvar);
length_center=length(unique(idx));%���ĵĸ���
[r,clusterCenter,clusterCount] = isodata(lbpLen,precenter,A,N,featureLen ,length_type,minnumber,stdvarmean,mindistance,3,2000);
% xlswrite('clucenter.xlsx',clusterCenter);
[m,n]=size(r);
for i=1:m
    I=find(r(i,:)>=1);
    for j=1:length(I)
        type(I(j))=i;
    end
end
createFolder('finaltest2',type);
for i=1:N
writeToFolder('finaltest2',num2str(type(i)),location{i,2},location{i,1});
end

