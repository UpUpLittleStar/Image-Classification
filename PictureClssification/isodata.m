%ISODATA算法的Ｍatlab程序
%相关函数说明见函数定义
%x=样本空间
%clusterNumber=预期聚类中心数目
%leastNumber=最小聚类中的样本数，少于此数将不能作为独立的样本
%stdvar=样本距离分布的标准差
%minmumDistance=两聚类中心的最小距离，小于此数将两个聚类合并
%maximumCluster=一次运算中可以合并的聚类中心的最大对数
%opCount=迭代运算次数
%n=x中元素个数
%number=x中元素特征数目
%s=聚类结果
%clusterCenter=聚类中心
%clusterCount = 聚类中心元素数目
function [s,clusterCenter,clusterCount] = isodata(lbpLen,precenter,x,n,number,clusterNumber,leastNumber,stdvar,minmumDistance,maximumCluster,opCount)
K = clusterNumber;
qn = leastNumber;
%qs =mean(stdvar(:));%修改
qs=stdvar;
qc = minmumDistance;
L = maximumCluster;%并没有使用
I = opCount;
num = number;
factor = 0.5;   %分裂计算时标准差的乘积因子
z = precenter;
nc = size(z,1);%初始聚类数目,16
opTimes = 1; %迭代运算次数计数器
while(opTimes < I)
    count = zeros(1,nc);  %聚类元素数目1*nc
    aveD=zeros(1,nc);
    disTocenter = zeros(n,nc);%n*nc元素总个数*nc
    ss = zeros(nc,n);
    %依据欧氏距离聚类
    for m = 1:n
        for p = 1:nc
            disTocenter(m,p) = distance(x(m,:),z(p,:),lbpLen,num); %计算各个元素距离各个中心之间的距离，m为元素的个数，p为聚类中心的个数
        end
        [minValue,index] = min(disTocenter(m,:));  %依据距离归类，获取第m个数据归属于第几个聚类,minValue是数值，index对应于p
        count(index) = count(index) + 1;%统计聚类中心p中的聚类的个数
        ss(index,m) = m;%将对应的m放入对应的聚类中
    end
    %修正聚类中心，计算元素到中心的平均距离
    for i = 1:nc
        [aveD(i),z(i,:)] = avTocenter(x(find(ss(i,:)),:),count(i),lbpLen,num);%[平均距离，聚类中心],x(find(ss(i,:)),:)每一列中的特征
    end
    %计算全部模式样本对应聚类中心的总的平均距离。
    aveAllD = allAvDis(aveD,count);
    bool = step_judge(opTimes,nc,I,K); %判断是进行分裂还是合并运算
    nct = nc;
    if (bool == 1)  %分裂计算(正确) 
        for i = 1:nc
            stdcluster(i,:) = clusterStd(x(find(ss(i,:)),:),z(i,:),count(i),num);
            %计算每个聚类中样本距离的标准差向量
            [maxQs(i),ind] = max(stdcluster(i,:)); %求每聚类中标准差最大分量
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
   elseif (bool == 0)  %合并
        centerD = centerDistance(z,nc,lbpLen,num);
        %Zij = centerD < qc; %查找小于设定最小中心距离的中心
        [indrow indcol] = find(centerD<qc);  %查找两个中心点,indow是i,indcol是j
        %indrowcol = [indrow indcol];
        for icount = 1:ceil(numel(indrow)/2) %对称矩阵，只计算一半即可
            if(indrow(icount) == indcol(icount))  %去掉自身距离(为0)
                continue;
            else
                newCenter = count(indrow(icount))*z(indrow(icount),:) + count(indcol(icount))*z(indcol(icount),:);
                newCenter = newCenter ./(count(indrow(icount))+count(indcol(icount))); %计算合并后的新的中心
                for zcount = 1:nc
                    centerTemp(zcount,:) = z(zcount,:);  %缓存聚类中心
                end
                z = zeros(nc-1,num);
                for zcount = 1:nc-1
                    if(zcount == indrow(icount) || zcount == indcol(icount))
                        z(zcount,:) = newCenter;
                    else
                        z(zcount,:) = centerTemp(zcount,:);
                    end
                end
                nc = nc - 1;  %合并，减少聚类中心数目
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
    count = zeros(1,nc);  %聚类元素数目1*nc
    disTocenter = zeros(n,nc);%n*nc元素总个数*nc
    ss = zeros(nc,n);
    %依据欧氏距离聚类
    for m = 1:n
        for p = 1:nc
            disTocenter(m,p) = distance(x(m,:),z(p,:),lbpLen,num); %计算各个元素距离各个中心之间的距离，m为元素的个数，p为聚类中心的个数
        end
        [minValue,index] = min(disTocenter(m,:));  %依据距离归类，获取第m个数据归属于第几个聚类,minValue是数值，index对应于p
        count(index) = count(index) + 1;%统计聚类中心p中的聚类的个数
        ss(index,m) = m;%将对应的m放入对应的聚类中
    end
s = ss;
clusterCenter = z;
% R=find(sum(abs(z),2)~=0);
% clusterCenter=z(R,:);
% T=find(sum(abs(count),2)~=0);
clusterCount = count;
% clusterCount=count(T,:);
