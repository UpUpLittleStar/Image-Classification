%某聚类标准差向量
%x聚类中元素矩阵，z聚类中心,k聚类元素维数,n——x中元素个数
function [delta] = clusterStd(x,z,n,k)
d = zeros(1,k);
for i = 1:n
    for j = 1:k
        d(j) = d(j) +(x(i,j)-z(j))^2;
    end
end
delta = sqrt(d./n);


