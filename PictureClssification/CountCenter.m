%%%%%%%%%%%%%%%%统计%%%%%%%%%%%%%%%%%%%%%%%%%%
%type:每个样本对应的类别，
%precenter:初始聚类中心坐标集，
%length_center：聚类中心的个数，
%minnumber:最小聚类数,
%stdvar:类内标准差均值向量集合,
%mindistance:两聚类中心的最小距离
function [type,precenter,length_center,minnumber,stdvarmean,mindistance]=CountCenter(idx,A,k)
N=length(idx);
center=unique(idx);%获取分类
length_center=length(unique(idx));%中心的个数
stdlen=size(A,2);
type=ones(N,1);
minnumber=N;
prec=A(center,:);
B=distanceCount(prec,k);
B=-1*B;
mindistance=min(B(:));
stdvar=zeros(1,stdlen);
count=0;
%stdvar=zeros(length_center,256);
for i=1:length_center
    I=find(idx==center(i));%获取聚类中心为center的坐标
    stdvar=stdvar+clusterStd(A(I,:),prec(i,:),length(I),stdlen);
    %stdvar(i,:)=clusterStd(A(I,:),precenter(i,:),length(I),256);
    if(length(I)<minnumber)
        minnumber=length(I);
    end
    for j=1:length(I)
        type(I(j))=i;     
    end
end
if(minnumber<N/length_center/3*2)
    minnumber=round(N/length_center/3*2);
    for i=1:length_center
        I=find(idx==center(i));
        if(length(I)<minnumber)
            center(i)=0;
            count=count+1;
        end
    end
    center=center(center~=0);
    length_center=length_center-count;       
end
precenter=A(center,:);%获取中心的所有坐标
stdvarmean=stdvar./length_center;%方差的均值
