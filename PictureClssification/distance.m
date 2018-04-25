%计算x1,x2之间的欧氏距离函数,k为x1,x2中的lbp元素个数,w为总特征
function y = distance(x1,x2,k,w)
d = 0;
d1=0;
d2=0;
if(k>0)
    for i = 1:k
        d1 = d1+ (x1(i) - x2(i))^2;
    end
    for i=k+1:w
        d2 = d2+ (x1(i) - x2(i))^2;
    end
    d=d1/w*(w-k)+d2/w*k;
else
    for i=1:w
        d=d+ (x1(i) - x2(i))^2;
    end
end
y = sqrt(d);

