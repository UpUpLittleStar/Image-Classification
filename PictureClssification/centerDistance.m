%���������������֮��ľ���
%z�������ģ�clusterNumber������Ŀ,kά��
function [y] = centerDistance(z,clusterNumber,k,num)
y = zeros(clusterNumber-1);
for i = 1:clusterNumber-1
    for j = i+1:clusterNumber
        y(i,j) = distance(z(i,:),z(j,:),k,num);
        y(j,i) = y(i,j);
    end
end


