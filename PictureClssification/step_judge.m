%���Ѻϲ��о�����,op_count�����������,clusterNumber��ǰ������Ŀ,MAXIMUM_OPΪ�����ܴ�����clusterΪ����ϲ�����Ŀ
%y����ֵ:1��ʾ���ѣ�0��ʾ�ϲ���2��ʾ��������
function y = step_judge(op_count,clusterNumber,MAXIMUM_OP,K)
if (op_count == MAXIMUM_OP)
    y = 2;  %��������
    return;
end
if(clusterNumber <= K/2)
    y = 1;
elseif(clusterNumber > K*2) %ż������������Ŀ�����涨��2��
    y = 0;
elseif( mod(op_count,2) == 0)
    y = 0;
else
    y= 1;
end