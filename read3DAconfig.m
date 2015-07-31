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
end

