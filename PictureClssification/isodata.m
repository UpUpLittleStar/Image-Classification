%ISODATA�㷨�ģ�atlab����
%��غ���˵������������
%x=�����ռ�
%clusterNumber=Ԥ�ھ���������Ŀ
%leastNumber=��С�����е������������ڴ�����������Ϊ����������
%stdvar=��������ֲ��ı�׼��
%minmumDistance=���������ĵ���С���룬С�ڴ�������������ϲ�
%maximumCluster=һ�������п��Ժϲ��ľ������ĵ�������
%opCount=�����������
%n=x��Ԫ�ظ���
%number=x��Ԫ��������Ŀ
%s=������
%clusterCenter=��������
%clusterCount = ��������Ԫ����Ŀ
function [s,clusterCenter,clusterCount] = isodata(lbpLen,precenter,x,n,number,clusterNumber,leastNumber,stdvar,minmumDistance,maximumCluster,opCount)
K = clusterNumber;
qn = leastNumber;
%qs =mean(stdvar(:));%�޸�
qs=stdvar;
qc = minmumDistance;
L = maximumCluster;%��û��ʹ��
I = opCount;
num = number;
factor = 0.5;   %���Ѽ���ʱ��׼��ĳ˻�����
z = precenter;
nc = size(z,1);%��ʼ������Ŀ,16
opTimes = 1; %�����������������
while(opTimes < I)
    count = zeros(1,nc);  %����Ԫ����Ŀ1*nc
    aveD=zeros(1,nc);
    disTocenter = zeros(n,nc);%n*ncԪ���ܸ���*nc
    ss = zeros(nc,n);
    %����ŷ�Ͼ������
    for m = 1:n
        for p = 1:nc
            disTocenter(m,p) = distance(x(m,:),z(p,:),lbpLen,num); %�������Ԫ�ؾ����������֮��ľ��룬mΪԪ�صĸ�����pΪ�������ĵĸ���
        end
        [minValue,index] = min(disTocenter(m,:));  %���ݾ�����࣬��ȡ��m�����ݹ����ڵڼ�������,minValue����ֵ��index��Ӧ��p
        count(index) = count(index) + 1;%ͳ�ƾ�������p�еľ���ĸ���
        ss(index,m) = m;%����Ӧ��m�����Ӧ�ľ�����
    end
    %�����������ģ�����Ԫ�ص����ĵ�ƽ������
    for i = 1:nc
        [aveD(i),z(i,:)] = avTocenter(x(find(ss(i,:)),:),count(i),lbpLen,num);%[ƽ�����룬��������],x(find(ss(i,:)),:)ÿһ���е�����
    end
    %����ȫ��ģʽ������Ӧ�������ĵ��ܵ�ƽ�����롣
    aveAllD = allAvDis(aveD,count);
    bool = step_judge(opTimes,nc,I,K); %�ж��ǽ��з��ѻ��Ǻϲ�����
    nct = nc;
    if (bool == 1)  %���Ѽ���(��ȷ) 
        for i = 1:nc
            stdcluster(i,:) = clusterStd(x(find(ss(i,:)),:),z(i,:),count(i),num);
            %����ÿ����������������ı�׼������
            [maxQs(i),ind] = max(stdcluster(i,:)); %��ÿ�����б�׼��������
            if(maxQs(i) > qs && ((aveD(i) > aveAllD && count(i)>2*(qn+1)) || nc <= K/2))
                lqs =z(i,ind) +  factor * maxQs(i);
                hqs = z(i,ind) - factor * maxQs(i);
                temp=[z;z(i,:)];
                temp(nct+1,ind) = lqs;
                temp(i,ind) = hqs;
                z = temp;
                nct = nct + 1;
            end
        end
        nc = nct;
   elseif (bool == 0)  %�ϲ�
        centerD = centerDistance(z,nc,lbpLen,num);
        %Zij = centerD < qc; %����С���趨��С���ľ��������
        [indrow indcol] = find(centerD<qc);  %�����������ĵ�,indow��i,indcol��j
        %indrowcol = [indrow indcol];
        for icount = 1:ceil(numel(indrow)/2) %�Գƾ���ֻ����һ�뼴��
            if(indrow(icount) == indcol(icount))  %ȥ���������(Ϊ0)
                continue;
            else
                newCenter = count(indrow(icount))*z(indrow(icount),:) + count(indcol(icount))*z(indcol(icount),:);
                newCenter = newCenter ./(count(indrow(icount))+count(indcol(icount))); %����ϲ�����µ�����
                for zcount = 1:nc
                    centerTemp(zcount,:) = z(zcount,:);  %�����������
                end
                z = zeros(nc-1,num);
                for zcount = 1:nc-1
                    if(zcount == indrow(icount) || zcount == indcol(icount))
                        z(zcount,:) = newCenter;
                    else
                        z(zcount,:) = centerTemp(zcount,:);
                    end
                end
                nc = nc - 1;  %�ϲ������پ���������Ŀ
            end
        end
    else
        opTimes=I;
    end
    opTimes = opTimes + 1;
end
    I=find(count==0);
    nc=nc-length(I);
    z(I,:)=[];
    count = zeros(1,nc);  %����Ԫ����Ŀ1*nc
    disTocenter = zeros(n,nc);%n*ncԪ���ܸ���*nc
    ss = zeros(nc,n);
    %����ŷ�Ͼ������
    for m = 1:n
        for p = 1:nc
            disTocenter(m,p) = distance(x(m,:),z(p,:),lbpLen,num); %�������Ԫ�ؾ����������֮��ľ��룬mΪԪ�صĸ�����pΪ�������ĵĸ���
        end
        [minValue,index] = min(disTocenter(m,:));  %���ݾ�����࣬��ȡ��m�����ݹ����ڵڼ�������,minValue����ֵ��index��Ӧ��p
        count(index) = count(index) + 1;%ͳ�ƾ�������p�еľ���ĸ���
        ss(index,m) = m;%����Ӧ��m�����Ӧ�ľ�����
    end
s = ss;
clusterCenter = z;
% R=find(sum(abs(z),2)~=0);
% clusterCenter=z(R,:);
% T=find(sum(abs(count),2)~=0);
clusterCount = count;
% clusterCount=count(T,:);
