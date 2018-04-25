%单幅图像进行分类，clusterCenter为已有的聚类中心
function [type]=singledeal(picname)
lbpLen=256;
hsvLen=12;
histlbp=zeros(1,lbpLen);
histhsv=zeros(1,hsvLen);
templbp=zeros(1,lbpLen);
temphsv=zeros(1,hsvLen);
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
clusterCenter=xlsread('clucenter.xlsx');
N=size(clusterCenter,1);
I1=rgb2gray(I);%灰度化图像
[r,c]=size(I1);
ss=r*c;
I2=rgb2hsv(I);%HSV化图像
graylbp=LBP(I1,SP,0,'i'); 
 [r,c]=size(graylbp);
s2=r*c; 
 H=round(I2(:,:,1)*360);
histlbp(1,1)=length(find(graylbp==0))/s2*100;
for x=2:lbpLen
    templbp(1,x)=length(find(graylbp==(x-1)))/s2*100;
    histlbp(1,x)=histlbp(1,x-1)+templbp(1,x);
end
 histhsv(1,1)=(length(find(H<=360&H>=345))+length(find(H<15&H>=0)))/ss*100;
for y=2:hsvLen 
     temphsv(1,y)=length(find(H<15+(y-1)*30&H>=15+(y-2)*30))/ss*100;
     histhsv(1,y)=histhsv(1,y-1)+temphsv(1,y); 
end
A=[histlbp,histhsv];
B=repmat(A,N,1);
C=clusterCenter-B;
D=C*C';
E=diag(D);
[x,type]=min(E);

