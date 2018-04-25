function createFolder(filepath,type)
mkdir(filepath);
center=unique(type);
N=length(center);
for j=1:N
    filename=strcat(filepath,'/',num2str(center(j)));
    mkdir(filename);
end