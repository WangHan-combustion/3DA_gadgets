function read3DAserial(filename)

fid = fopen(filename,'r');
dims = fread(fid,11,'integer*4');
dt = fread(fid,1,'real*8');
time = fread(fid,1,'real*8');
names = cell(1,dims(11));
for ii = 1:dims(11)
    names{ii} = strtrim(char(fread(fid,8,'char*1')));
end

data = cell(1,dims(11));
for ii = 1:dims(11)
    data{ii} = fread(fid,dims(1)*dims(2)*dims(3),'real*8');
    data{ii} = reshape(data{ii},[dims(1) dims(2) dims(3)]);
end

ierr = fclose(fid);

% Summary
fprintf('SUMMARY\n')
fprintf('===========================\n')
fprintf('nx x ny x nz = %3i x %3i x %3i\n',dims(1),dims(2),dims(3))
fprintf('x -> %3i to %3i',dims(4),dims(5))
fprintf('y -> %3i to %3i',dims(6),dims(7))
fprintf('z -> %3i to %3i',dims(8),dims(9))
fprintf('nover = %3i, nvar = %3i\n',dims(10),dims(11))
fprintf('dt = %15.7E, time = %15.7E\n',dt,time)
fprintf('Variables:\n')
for ii = 1:dims(11)
    fprintf([names{ii},' '])
end
fprintf('\n')
fprintf('File closed with message %i\n',ierr)