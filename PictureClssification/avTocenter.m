%���������Ԫ�ص����ĵ�ƽ������,xΪ�����е�Ԫ�أ�zΪ��������
%nΪx��Ԫ�ظ�����kΪԪ��ά��
function [y,z] = avTocenter(x,n,k,m);
z = center(x,n,m); %����һ����������ľ�ֵ
d = 0;
for i = 1:n
    d = d + distance(x(i,:),z,k,m);
end
y = d./n;
