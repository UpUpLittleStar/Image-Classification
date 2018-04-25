%%%%%%%%%%%%%主函数%%%%%%%%%%%%%%%%
file_path =  'picture\';% 图像文件夹路径
location=recievePicture(file_path);
lbpLen=256;
hsvLen=12;
featureLen=lbpLen+hsvLen;
% [A,B]=lbptest(location);
% A=[A,B];
% xlswrite('feature.xlsx',A);
A=xlsread('feature.xlsx');
S=distanceCount(A,lbpLen);%相似度矩阵
idx=AP(S);
N=length(idx);%样本的总长度
[type,precenter,length_type,minnumber,stdvar,mindistance]=CountCenter(idx,A,lbpLen);%样本的分类数,聚类中心的特征，聚类的总个数
stdvarmean=mean(stdvar);
length_center=length(unique(idx));%中心的个数
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

