function res = chemtable_lookup(chemtable,ZMean,ZVar,C,var_names)
%% Find the indices corresponding to the specified condition
for ii = 1:chemtable.nZMean-1
    if (chemtable.ZMean(ii)-ZMean)*(chemtable.ZMean(ii+1)-ZMean)<=0
        idx_ZMean = ii;
        break;
    end
end

for ii = 1:chemtable.nZVar-1
    if (chemtable.ZVar(ii)-ZVar)*(chemtable.ZVar(ii+1)-ZVar)<=0
        idx_ZVar = ii;
        break;
    end
end

for ii = 1:chemtable.n3-1
    if (chemtable.Z3(ii)-C)*(chemtable.Z3(ii+1)-C)<=0
        idx_C = ii;
        break;
    end
end
%% Read the table and interpolate
% Read
buf_3D = zeros(2,2,2,chemtable.nvar_out);
buf_3D(1,1,1,:) = chemtable.data(idx_ZMean  ,idx_ZVar  ,idx_C  ,:);
buf_3D(1,1,2,:) = chemtable.data(idx_ZMean  ,idx_ZVar  ,idx_C+1,:);
buf_3D(1,2,1,:) = chemtable.data(idx_ZMean  ,idx_ZVar+1,idx_C  ,:);
buf_3D(1,2,2,:) = chemtable.data(idx_ZMean  ,idx_ZVar+1,idx_C+1,:);
buf_3D(2,1,1,:) = chemtable.data(idx_ZMean+1,idx_ZVar  ,idx_C  ,:);
buf_3D(2,1,2,:) = chemtable.data(idx_ZMean+1,idx_ZVar  ,idx_C+1,:);
buf_3D(2,2,1,:) = chemtable.data(idx_ZMean+1,idx_ZVar+1,idx_C  ,:);
buf_3D(2,2,2,:) = chemtable.data(idx_ZMean+1,idx_ZVar+1,idx_C+1,:);

% Interpolate
% C
buf_2D = buf_3D(:,:,1,:) + ...
    (C-chemtable.Z3(idx_C))/ ...
    (chemtable.Z3(idx_C+1)-chemtable.Z3(idx_C))* ...
    (buf_3D(:,:,2,:)-buf_3D(:,:,1,:));
buf_2D = squeeze(buf_2D);

% ZVar
buf_1D = buf_2D(:,1,:) + ...
    (ZVar-chemtable.ZVar(idx_ZVar))/ ...
    (chemtable.ZVar(idx_ZVar+1)-chemtable.ZVar(idx_ZVar))* ...
    (buf_2D(:,2,:)-buf_2D(:,1,:));
buf_1D = squeeze(buf_1D);

% ZMean
res = buf_1D(1,:) + ...
    (ZMean-chemtable.ZMean(idx_ZMean))/ ...
    (chemtable.ZMean(idx_ZMean+1)-chemtable.ZMean(idx_ZMean))* ...
    (buf_1D(2,:)-buf_1D(1,:));
res = squeeze(res);

%% look for specific variable
if nargin>4
    res_ = res;
    res = zeros(1,length(var_names));
    for isc = 1:length(var_names)
        for ii = 1:chemtable.nvar_out
            if strcmp(var_names{isc},chemtable.name{ii})
                res(isc) = res_(ii);
                break;
            end
        end
    end
end