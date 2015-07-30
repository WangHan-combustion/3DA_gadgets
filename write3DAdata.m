function write3DAdata( data_3DA, filename )
% This script converts a matlab data struct to a 3DA data binary file
% INPUT :
%           data_3DA : matlab data struct
%                       'nx','ny','nz','nvar','dt','time','data'
%           filename : the file name of the 3DA restart file
% OUTPUT :
%           none
% ----------------------------------------------------------------

fid = fopen(filename);
fprintf('Grid : %i x %i x %i\n',data_3DA.nx,data_3DA.ny,data_3DA.nz);
fwrite(fid,data_3DA.nx,'int');
fwrite(fid,data_3DA.ny,'int');
fwrite(fid,data_3DA.nz,'int');
fwrite(fid,data_3DA.nvar,'int');
fprintf('Data file at time : %15.7e\n',data_3DA.time)
fwrite(fid,data_3DA.dt,'double');
fwrite(fid,data_3DA.time,'double');

for ivar = 1:nvar
    fprintf(data_3DA.data(ivar).name)
    fwrite(fid,data_3DA.data(ivar).name,'char*1');
end
fprintf('\n')

for ivar = 1:nvar
    tmp = reshape(data_3DA.data(ivar).value, [], 1);
    fwrite(fid,tmp,'double');
end
fclose(fid);
end

