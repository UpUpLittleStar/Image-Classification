%计算全部模式样本对其相应聚类中心的总平均距离
%z为所有聚类中心，n为对应的聚类中的元素个数
function [m] = allAvDis(z,count)
d = z*count';
m = d/sum(count);