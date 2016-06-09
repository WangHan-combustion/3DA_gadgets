function write3DAconfig( config,filename )
% This script write config file for 3DA
% INPUT :
%           matlab struc config
%               "x", "y", "z", "mask", "bc"
%           filename : the file name of the 3DA restart file
% OUTPUT :
%           none
% ----------------------------------------------------------------

% Sanity check
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

%open file
fid = fopen(filename, 'wt');

if (config.icyl)
    fprintf('    icyl = %i\n', config.icyl);
end
fprintf('Grid : %i x %i x %i\n',config.nx,config.ny,config.nz);

fwrite(fid, strpad(config.simu_name,64), 'char*1');
fwrite(fid, config.icyl, 'int32');
fwrite(fid, config.xper, 'int32');
fwrite(fid, config.yper, 'int32');
fwrite(fid, config.zper, 'int32');
fwrite(fid, config.nx, 'int32');
fwrite(fid, config.ny, 'int32');
fwrite(fid, config.nz, 'int32');

fwrite(fid, config.x, 'double');
fwrite(fid, config.y, 'double');
fwrite(fid, config.z, 'double');

tmp = reshape(config.mask,[],1);
fwrite(fid, tmp, 'int32');

if (~isfield(config, 'bc') || isempty(config.bc))
    config.bc = zeros(config.nx,config.ny,config.nz);
end

tmp = reshape(config.bc,[],1);
fwrite(fid, tmp, 'int32');

end

