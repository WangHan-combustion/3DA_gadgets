function Inflow_File_Reader_3DA(filename)
iunit = fopen(filename,'r');
dims = fread(iunit,4,'integer*4');
inflow_freq = fread(iunit,1,'real*8');
time = fread(iunit,1,'real*8');
for isc = 1:dims(4)
    data(isc).name = strtrim(char(fread(iunit,8,'char*1')));
    fprintf(data(isc).name)
end
fprintf('\n');
icyl = fread(iunit,1,'integer*4');
y = fread(iunit,dims(2)+1,'real*8');
z = fread(iunit,dims(3)+1,'real*8');

for ii = 1:dims(1)
    for isc = 1:dims(4)
        buf = fread(iunit,dims(2)*dims(3),'real*8');
        data(isc).value(:,:,ii) = reshape(buf,[dims(2) dims(3)]);
    end
end
% Double check if no information left in the file
buf = fread(iunit,1,'real*8');
if (~isempty(buf))
    warning('All data is loaded before file ends. Check.')
end

fclose(iunit);
save([filename,'_',num2str(dims(1),'%4.3e'),'.mat'], ...
    'dims','inflow_freq','time','icyl','y','z','data','-v7.3')