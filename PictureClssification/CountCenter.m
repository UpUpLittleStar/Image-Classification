%%%%%%%%%%%%%%%%ͳ��%%%%%%%%%%%%%%%%%%%%%%%%%%
%type:ÿ��������Ӧ�����
%precenter:��ʼ�����������꼯��
%length_center���������ĵĸ�����
%minnumber:��С������,
%stdvar:���ڱ�׼���ֵ��������,
%mindistance:���������ĵ���С����
function [type,precenter,length_center,minnumber,stdvarmean,mindistance]=CountCenter(idx,A,k)
N=length(idx);
center=unique(idx);%��ȡ����
length_center=length(unique(idx));%���ĵĸ���
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
    I=find(idx==center(i));%��ȡ��������Ϊcenter������
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
precenter=A(center,:);%��ȡ���ĵ���������
stdvarmean=stdvar./length_center;%����ľ�ֵ
