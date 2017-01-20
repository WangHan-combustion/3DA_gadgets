function stat_spray = read3DAStat2DSpray(filename)
fid = fopen(filename,'r');

buf = fread(fid,4,'integer*4');
stat_spray.nx = buf(1);
stat_spray.ny = buf(2);
stat_spray.nz = buf(3);
stat_spray.nvar = buf(4);

stat_spray.delta_t = fread(fid,1,'real*8');
stat_spray.time = fread(fid,1,'real*8');

stat_spray.name = cell(1,stat_spray.nvar);
for i = 1:stat_spray.nvar
    stat_spray.name{i} = strtrim(fread(fid,64,'*char'));
end

stat_spray.data = zeros(stat_spray.nx,stat_spray.ny,stat_spray.nvar);
for i = 1:stat_spray.nvar
    stat_spray.data(:,:,i) = reshape(fread(fid,stat_spray.nx*stat_spray.ny,'real*8'), ...
        stat_spray.nx,stat_spray.ny);
end


fclose(fid);
save([filename,'.mat'],'stat_spray')
