%ĳ�����׼������
%x������Ԫ�ؾ���z��������,k����Ԫ��ά��,n����x��Ԫ�ظ���
function [delta] = clusterStd(x,z,n,k)
d = zeros(1,k);
for i = 1:n
    for j = 1:k
        d(j) = d(j) +(x(i,j)-z(j))^2;
    end
end
delta = sqrt(d./n);


