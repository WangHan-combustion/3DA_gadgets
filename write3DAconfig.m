function write3DAconfig( filename, config )
% This script write config file for 3DA
% INPUT :
%           matlab struc config
%               "x", "y", "z", "mask", "bc"
%           filename : the file name of the 3DA restart file
% OUTPUT :
%           none
% ----------------------------------------------------------------
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

if (isempty(config.bc))
    config.bc = zeros(config.nx,config.ny,config.nz);
end

tmp = reshape(config.bc,[],1);
fwrite(fid, tmp, 'int32');

end

