%计算聚类中元素到中心的平均距离,x为聚类中的元素，z为聚类中心
%n为x中元素个数，k为元素维数
function [y,z] = avTocenter(x,n,k,m);
z = center(x,n,m); %计算一个聚类里面的均值
d = 0;
for i = 1:n
    d = d + distance(x(i,:),z,k,m);
end
y = d./n;
