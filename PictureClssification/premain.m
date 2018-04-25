[data,path,location]=xlsread('location.xlsx');
idx=xlsread('cc.xlsx');
N=length(idx);
center=unique(idx);
length_center=length(unique(idx));%还差个分类啊
type=ones(N,1);
for i=1:length_center
    I=find(idx==center(i));
    for j=1:length(I)
        type(I(j))=i;
    end
end
result=cell(N,4);

for i=1:N
    result{i,1}=data(i);
    result{i,2}=path{i};
    result{i,3}=idx(i);
    result{i,4}=type(i);
end
headers={'index','path','center','type'};
xlswrite('result.xlsx',[headers;result]);





