function read3DApartData(filename)
fid = fopen(filename);
npart = fread(fid,1,'integer*4');
part_size = fread(fid,1,'integer*4');
dt = fread(fid,1,'real*8');
time = fread(fid,1,'real*8');
ref = {'x','y','z','u','v','w','m','d','rho','T','dmdt','beta','tbreak', ...
    'nparcel','dt','i','j','k','tag','stop'};
part = zeros(npart,length(ref));
for ipart = 1:npart
    for ii = 1:15
        part(ipart,ii) = fread(fid,1,'real*8');
    end
    for ii = 16:length(ref)
        part(ipart,ii) = fread(fid,1,'integer*4');
    end
end

fclose(fid);

save('./part_data.mat','npart','part_size','dt','time','ref','part')