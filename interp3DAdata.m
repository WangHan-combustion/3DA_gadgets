function [ data_target ] = interp3DAdata( filename_data_target, filename_data_source, filename_config_target, filename_config_source, method )
% This script interpolate 3DA data file to the new grid
% INPUT :
%           filename_data_target : file name of the target data file
%           filename_data_source : file name of the source data file
%           filename_config_target : file name of the target config file
%           filename_config_source : file name of the source config file
%
% OUTPUT :
%           data_new : struct of the target data
% ----------------------------------------------------------------
%%
[ config_target ] = read3DAconfig( filename_config_target );
[ config_source ] = read3DAconfig( filename_config_source );
[ data_source ] = read3DAdata(filename_data_source,[]);
%%
data_target = data_source;
data_target.nx = config_target.nx;
data_target.ny = config_target.ny;
data_target.nz = config_target.nz;
%%
% note :    Vq = interp3(X,Y,Z,V,Xq,Yq,Zq)
%           size(V) = [length(Y) length(X) length(Z)].
%           X and Y in the matlab interpolation notation is different from
%           that in 3DA
if (nargin<5 || isempty(method))
    method = 'linear';
end
%%
[Xq,Yq,Zq] = meshgrid(config_target.y(2:end), config_target.x(2:end), config_target.z(2:end));
for ivar = 1:data_target.nvar
    fprintf(data_source.data(ivar).name);
    fprintf('\n')
    data_target.data(ivar).value = ...
        interp3(config_source.y(2:end), config_source.x(2:end), config_source.z(2:end), data_source.data(ivar).value, ...
        Xq,Yq,Zq, method, 0.0);
end
%%
if (~isempty(filename_data_target))
    write3DAdata( data_target, filename_data_target );
end
end

