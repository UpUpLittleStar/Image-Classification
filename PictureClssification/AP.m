function idx = AP(S)
%X = [randn(50,2)+ones(50,2);randn(50,2)-ones(50,2);randn(50,2)+[ones(50,1),-ones(50,1)]];
N = size(S,1);%获取行数
A=zeros(N,N);
R=zeros(N,N); % Initialize messages 
lam=0.5; % Set damping factor阻尼系数
 
same_time = -1;
for iter=1:10000%迭代次数？？
    % Compute responsibilities
    Rold=R;
    AS=A+S;
    [Y,I]=max(AS,[],2);%每行最大值,结果存在Y里,I里存的是每行最大值的列位置,1则为每列最大值
    for i=1:N
        AS(i,I(i))=-1000;%每行的最大值替换为1000
    end
    [Y2,I2]=max(AS,[],2);
    R=S-repmat(Y,[1,N]);%将Y复制N列,R(i,k)=s(i,k)-{AS(i,k')}max
    for i=1:N
        R(i,I(i))=S(i,I(i))-Y2(i);%对于每行最大值对应列做特殊处理
    end
    R=(1-lam)*R+lam*Rold; % Dampen responsibilities，预防震荡
    % Compute availabilities
    Aold=A;
    Rp=max(R,0);%返回每个数和0比的较大值
    for k=1:N
        Rp(k,k)=R(k,k);
    end
    A=repmat(sum(Rp,1),[N,1])-Rp;%为什么是减
    dA=diag(A);
    A=min(A,0);
    for k=1:N
        A(k,k)=dA(k);
    end;
    A=(1-lam)*A+lam*Aold; % Dampen availabilities
 
    if(same_time == -1)
        E=R+A;
        [tt idx_old] = max(E,[],2);
        same_time = 0;
    else
        E=R+A;
        [tt idx] = max(E,[],2);
 
        if(sum(abs(idx_old-idx)) == 0)
            same_time = same_time + 1;
            if(same_time == 10)
                iter
                break;
            end
        end
        idx_old = idx;
end
end
E=R+A;
[tt idx] = max(E,[],2);
 
% figure;
% for i=unique(idx)%去除重复的数
%     ii=find(idx==i);
%     h=plot(x(ii),y(ii),'o');
%     hold on;
%     col=rand(1,3);
%     set(h,'Color',col,'MarkerFaceColor',col);
%     xi1=x(i)*ones(size(ii)); xi2=y(i)*ones(size(ii));
%     line([x(ii)',xi1]',[y(ii)',xi2]','Color',col);
% end;
