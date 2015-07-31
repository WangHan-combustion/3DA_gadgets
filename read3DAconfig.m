function [ config ] = read3DAconfig( filename )
% This script converts a matlab data struct to a 3DA data binary file
% INPUT :
%           filename : the file name of the 3DA config file
% OUTPUT :
%           matlab struc config
%               "x", "y", "z", "mask", "bc", "simu_name", "icyl", 
%               "xper", "yper", "zper", "nx", "ny", "nz"
% ----------------------------------------------------------------
fid = fopen(filename);

config.simu_name = strtrim(char(fread(fid,64,'char*1')'));
config.icyl = fread(fid,1,'int32');
config.xper = fread(fid,1,'int32');
config.yper = fread(fid,1,'int32');
config.zper = fread(fid,1,'int32');
config.nx = fread(fid,1,'int32');
config.ny = fread(fid,1,'int32');
config.nz = fread(fid,1,'int32');

fprintf('Grid : %i x %i x %i\n',config.nx,config.ny,config.nz);
if (config.icyl)
    fprintf('    icyl = %i\n', config.icyl);
end

config.x = fread(fid,config.nx+1,'double');
config.y = fread(fid,config.ny+1,'double');
config.z = fread(fid,config.nz+1,'double');

tmp = fread(fid,config.nx*config.ny*config.nz,'int32');
config.mask = reshape(tmp,[config.nx, config.ny, config.nz]);
tmp = fread(fid,config.nx*config.ny*config.nz,'int32');
if (~isempty(tmp))
    config.bc = reshape(tmp,[config.nx, config.ny, config.nz]);
else
    config.bc = zeros(config.nx,config.ny,config.nz);
end

if (config.nx~=length(config.x)-1 || config.ny~=length(config.y)-1 || config.nz~=length(config.z)-1)
    error('Size in the config file does not mathch coordinate arrays.')
end

if (any(diff(config.x)<=0) || any(diff(config.y)<=0) || any(diff(config.z)<=0))
    error('Coordinate array is not monotonically increasing.')
end

size_tmp = size(config.mask);
if (config.nx~=size_tmp(1) || config.ny~=size_tmp(2) || config.nz~=size_tmp(3))
    error('Size in the config file does not match mask')
end

if (isfield(config, 'bc') && ~isempty(config.bc))
    size_tmp = size(config.bc);
    if (config.nx~=size_tmp(1) || config.ny~=size_tmp(2) || config.nz~=size_tmp(3))
        error('Size in the config file does not match mask')
    end
end

end

