function idx = AP(S)
%X = [randn(50,2)+ones(50,2);randn(50,2)-ones(50,2);randn(50,2)+[ones(50,1),-ones(50,1)]];
N = size(S,1);%��ȡ����
A=zeros(N,N);
R=zeros(N,N); % Initialize messages 
lam=0.5; % Set damping factor����ϵ��
 
same_time = -1;
for iter=1:10000%������������
    % Compute responsibilities
    Rold=R;
    AS=A+S;
    [Y,I]=max(AS,[],2);%ÿ�����ֵ,�������Y��,I������ÿ�����ֵ����λ��,1��Ϊÿ�����ֵ
    for i=1:N
        AS(i,I(i))=-1000;%ÿ�е����ֵ�滻Ϊ1000
    end
    [Y2,I2]=max(AS,[],2);
    R=S-repmat(Y,[1,N]);%��Y����N��,R(i,k)=s(i,k)-{AS(i,k')}max
    for i=1:N
        R(i,I(i))=S(i,I(i))-Y2(i);%����ÿ�����ֵ��Ӧ�������⴦��
    end
    R=(1-lam)*R+lam*Rold; % Dampen responsibilities��Ԥ����
    % Compute availabilities
    Aold=A;
    Rp=max(R,0);%����ÿ������0�ȵĽϴ�ֵ
    for k=1:N
        Rp(k,k)=R(k,k);
    end
    A=repmat(sum(Rp,1),[N,1])-Rp;%Ϊʲô�Ǽ�
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
% for i=unique(idx)%ȥ���ظ�����
%     ii=find(idx==i);
%     h=plot(x(ii),y(ii),'o');
%     hold on;
%     col=rand(1,3);
%     set(h,'Color',col,'MarkerFaceColor',col);
%     xi1=x(i)*ones(size(ii)); xi2=y(i)*ones(size(ii));
%     line([x(ii)',xi1]',[y(ii)',xi2]','Color',col);
% end;
