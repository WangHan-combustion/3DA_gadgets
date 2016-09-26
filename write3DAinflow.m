function write3DAinflow(matlab_data_file,filename)
load(matlab_data_file);

if (nargin<2)
    filename = 'inflow';
end

fid = fopen(filename,'w');
fwrite(fid,dims,'integer*4');
fwrite(fid,inflow_freq,'real*8');
fwrite(fid,time,'real*8');
for isc = 1:dims(4)
    fwrite(fid,data(isc).name{1},'char*1',8-length(data(isc).name{1}));
end
fwrite(fid,icyl,'integer*4');
fwrite(fid,y,'real*8');
fwrite(fid,z,'real*8');

for ii = 1:dims(1)
    for isc = 1:dims(4)
        fwrite(fid,data(isc).value(:,:,ii),'real*8');
    end
end

fclose(fid);