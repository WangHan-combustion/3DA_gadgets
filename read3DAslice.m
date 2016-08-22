function slice = read3DAslice(dirname,direction)
files = dir([dirname,'/data.*']);
nfiles = length(files);
slices = cell(1,nfiles);
for ii = 1:nfiles
    slices{ii} = read3DAslice_1file([dirname,'/',files(ii).name],direction);
end
slice = rmfield(slices{1},{'imin_','imax_','jmin_','jmax_','kmin_','kmax_'});
for ivar = 1:slice.nvar
    fprintf(slice.var_name{ivar})
    fprintf(' ')
end
fprintf('\n')
switch direction
    case 'x'
        dim1 = slice.ny;
        dim2 = slice.nz;
    case 'y'
        dim1 = slice.nx;
        dim2 = slice.nz;
    case 'z'
        dim1 = slice.nx;
        dim2 = slice.ny;
end
slice.data = zeros(dim1,dim2,slice.nvar);
switch direction
    case 'x'
        for ii = 1:nfiles
            slice.data(slices{ii}.jmin_-slices{ii}.nover:slices{ii}.jmax_-slices{ii}.nover, ...
                slices{ii}.kmin_-slices{ii}.nover:slices{ii}.kmax_-slices{ii}.nover, :) ...
                = slices{ii}.data;
        end
    case 'y'
        for ii = 1:nfiles
            slice.data(slices{ii}.imin_-slices{ii}.nover:slices{ii}.imax_-slices{ii}.nover, ...
                slices{ii}.kmin_-slices{ii}.nover:slices{ii}.kmax_-slices{ii}.nover, :) ...
                = slices{ii}.data;
        end
    case 'z'
        for ii = 1:nfiles
            slice.data(slices{ii}.imin_-slices{ii}.nover:slices{ii}.imax_-slices{ii}.nover, ...
                slices{ii}.jmin_-slices{ii}.nover:slices{ii}.jmax_-slices{ii}.nover, :) ...
                = slices{ii}.data;
        end
end
end

function slice = read3DAslice_1file(filename,direction)
fid = fopen(filename,'r');
% read front matters
slice.nx = fread(fid,1,'integer*4');
slice.ny = fread(fid,1,'integer*4');
slice.nz = fread(fid,1,'integer*4');
slice.imin_ = fread(fid,1,'integer*4');
slice.imax_ = fread(fid,1,'integer*4');
slice.jmin_ = fread(fid,1,'integer*4');
slice.jmax_ = fread(fid,1,'integer*4');
slice.kmin_ = fread(fid,1,'integer*4');
slice.kmax_ = fread(fid,1,'integer*4');
slice.nover = fread(fid,1,'integer*4');
slice.nvar = fread(fid,1,'integer*4');
slice.dt = fread(fid,1,'real*8');
slice.time = fread(fid,1,'real*8');
% read variable names
slice.var_name = cell(1,slice.nvar);
for ivar = 1:slice.nvar
    slice.var_name{ivar} = strtrim(char(fread(fid,8,'char*1')'));
end
% read the data
switch direction
    case ('x')
        ny_ = slice.jmax_-slice.jmin_+1;
        nz_ = slice.kmax_-slice.kmin_+1;
        slice.data = zeros(ny_, nz_, slice.nvar);
        data_size = ny_*nz_;
        dim1 = ny_;
        dim2 = nz_;
    case ('y')
        nx_ = slice.imax_-slice.imin_+1;
        nz_ = slice.kmax_-slice.kmin_+1;
        slice.data = zeros(nx_, nz_, slice.nvar);
        data_size = nx_*nz_;
        dim1 = nx_;
        dim2 = nz_;
    case ('z')
        nx_ = slice.imax_-slice.imin_+1;
        ny_ = slice.jmax_-slice.jmin_+1;
        slice.data = zeros(nx_, ny_, slice.nvar);
        data_size = nx_*ny_;
        dim1 = nx_;
        dim2 = ny_;
end
for ivar = 1:slice.nvar
    slice.data(:,:,ivar) = reshape(fread(fid,data_size,'real*8'), ...
        dim1,dim2);
end
% end of file
fclose(fid);
% save([filename,'.mat'],'slice','-v7.3');
end