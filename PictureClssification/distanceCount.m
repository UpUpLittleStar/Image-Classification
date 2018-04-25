%%%%%%%%%%%%%%%计算相似度矩阵%%%%%%%%%%%%%%%%%%%%%%%%
function S=distanceCount(A,k)
N=size(A,1);
M=size(A,2);
lbpLen=k;
hsvLen=M-k;
if(k>0)
    B=A(:,1:lbpLen);
    C=A(:,lbpLen+1:M);
    for i=1:N
        for j=i:N
            b=B(i,:)-B(j,:);
            SB(i,j)=b*b';
            SB(j,i)=SB(i,j);
        end
    end
    for i=1:N
        for j=i:N
            c=C(i,:)-C(j,:);
            SC(i,j)=c*c';
            SC(j,i)=SC(i,j);
        end
    end
    S=SB/M*hsvLen+SC/M*lbpLen;
else
     for i=1:N
        for j=i:N
            a=A(i,:)-A(j,:);
            S(i,j)=a*a';
            S(j,i)=S(i,j);
        end
     end
end
S=sqrt(S);
S=-1*S;
smean=mean(S(:));%平均数
r=min(S(:));%最小值
for i=1:N
    S(i,i)=smean;
end

