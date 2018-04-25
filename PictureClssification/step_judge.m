%分裂合并判决函数,op_count迭代运算次数,clusterNumber当前聚类数目,MAXIMUM_OP为迭代总次数，cluster为允许合并的数目
%y返回值:1表示分裂，0表示合并，2表示结束迭代
function y = step_judge(op_count,clusterNumber,MAXIMUM_OP,K)
if (op_count == MAXIMUM_OP)
    y = 2;  %不再运算
    return;
end
if(clusterNumber <= K/2)
    y = 1;
elseif(clusterNumber > K*2) %偶次运算或分类数目超过规定的2倍
    y = 0;
elseif( mod(op_count,2) == 0)
    y = 0;
else
    y= 1;
end