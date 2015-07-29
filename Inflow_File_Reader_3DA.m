function Inflow_File_Reader_3DA(filename)
iunit = fopen(filename,'r');
dims = fread(iunit,4,'integer*4');
inflow_freq = fread(iunit,1,'real*8');
time = fread(iunit,1,'real*8');
for ii = 1:dims(4)
    data(ii).name = strtrim(char(fread(iunit,8,'char*1')));
    fprintf(data(ii).name)
end
fprintf('\n');
icyl = fread(iunit,1,'integer*4');
y = fread(iunit,dims(2)+1,'real*8');
z = fread(iunit,dims(3)+1,'real*8');

cnt = 1;
while ~feof(iunit)
%     inflow_ntime(cnt) = fread(iunit,1,'integer*4');
    for ii = 1:dims(4)
        buf = fread(iunit,dims(2)*dims(3),'real*8');
        if (isempty(buf))
            break;
        end
        data(ii).value(:,:,cnt) = reshape(buf,[dims(2) dims(3)]);
    end
    cnt = cnt + 1;
end
fclose(iunit);
save([filename,'_',num2str(dims(1),'%4.3e'),'.mat'], ...
    'dims','inflow_freq','time','icyl','y','z','data')