function chemtable = readFPVchemtable(filename)
fid = fopen(filename,'r');

% Read sizes
chemtable.nZMean = fread(fid,1,'integer*4');
chemtable.nZVar  = fread(fid,1,'integer*4');
chemtable.n3     = fread(fid,1,'integer*4');
chemtable.nvar_out = fread(fid,1,'integer*4');

% Read the axis
chemtable.ZMean = fread(fid,chemtable.nZMean,'real*8');
chemtable.ZVar  = fread(fid,chemtable.nZVar,'real*8');
chemtable.Z3    = fread(fid,chemtable.n3,'real*8');

% Masks
buf = fread(fid,chemtable.nZMean*chemtable.nZVar*chemtable.n3,'integer*4');
chemtable.mask = reshape(buf,chemtable.nZMean,chemtable.nZVar,chemtable.n3);

% Read additional stuff
chemtable.combModel = strtrim(char(fread(fid,64,'char*1')'));

% Read variable names
chemtable.name = cell(1,chemtable.nvar_out);
for isc = 1:chemtable.nvar_out
    chemtable.name{isc} = strtrim(char(fread(fid,64,'char*1')'));
end

% Read data field
chemtable.data = zeros(chemtable.nZMean,chemtable.nZVar,chemtable.n3,chemtable.nvar_out);
for isc = 1:chemtable.nvar_out
    buf = fread(fid,chemtable.nZMean*chemtable.nZVar*chemtable.n3,'real*8');
    chemtable.data(:,:,:,isc) = reshape(buf,chemtable.nZMean,chemtable.nZVar,chemtable.n3);
end

fclose(fid);

save([filename,'.mat'],'chemtable')