%计算某个聚类新的聚类中心,x为聚类中的向量，n为聚类元素数目,k为向量维数
%返回为1 x k向量
function y = center(x,n,k)
if(n == 1)  %n=1时，不能使用sum函数计算中心
    d = x;
else
    d = sum(x)./n;
end
y =d;