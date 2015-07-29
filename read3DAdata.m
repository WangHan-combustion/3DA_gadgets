% This script converts the 3DA restart data file in to .mat format
% INPUT :
%           filename : the file name of the 3DA restart file
%           var_list : the name of variables of interest; empty if
%                      all variables are used
%           opt      : the axis on which the slides is taken
%           n_slide  : the index of the slide on the chosen axis
% OUTPUT :
%           A .mat file saved under name filename.mat
%           All information in the restart file is preserved
% ----------------------------------------------------------------
function read3DAdata(filename,var_list,opt,n_slide)
fid = fopen(filename);

nx = fread(fid,1,'int');
ny = fread(fid,1,'int');
nz = fread(fid,1,'int');
nvar = fread(fid,1,'int');

fprintf('Grid : %i x %i x %i\n',nx,ny,nz)

dt = fread(fid,1,'double');
time = fread(fid,1,'double');
fprintf('Data file at time : %15.7e\n',time)

if isempty(var_list)
    for ivar = 1:nvar
        data(ivar).name = strtrim(char(fread(fid,8,'char*1')'));
        fprintf(data(ivar).name)
    end
    fprintf('\n')
    
    for ivar = 1:nvar
        tmp = fread(fid,nx*ny*nz,'double');
        if nargin<3
            data(ivar).value = reshape(tmp,[nx ny nz]);
        else
            switch lower(opt)
                case 'x'
                    tmp = reshape(tmp,[nx ny nz]);
                    data(ivar).value = tmp(n_slide,:,:);
                case 'y'
                    tmp = reshape(tmp,[nx ny nz]);
                    data(ivar).value = tmp(:,n_slide,:);
                case 'z'
                    tmp = reshape(tmp,[nx ny nz]);
                    data(ivar).value = tmp(:,:,n_slide);
                otherwise
                    error('Invalid slides coordinate specified')
            end
        end
    end
else
    cnt = 1;
    idx = zeros(length(var_list));
    for ivar = 1:nvar
        % Save the data if in the list
        var_name_tmp = strtrim(char(fread(fid,8,'char*1')'));
        if cnt<=length(var_list)&&strcmp(var_name_tmp,var_list(cnt))
            data(cnt).name = var_list(cnt);
            idx(cnt) = ivar;
            cnt = cnt + 1;
        end
        fprintf(var_name_tmp);
        fprintf(' ')
    end
    fprintf('\n')
    
    cnt = 1;
    for ivar = 1:nvar
        if cnt<=length(var_list)&&ivar==idx(cnt)
            tmp = fread(fid,nx*ny*nz,'double');
            if nargin<3
                data(cnt).value = reshape(tmp,[nx ny nz]);
            else
                switch lower(opt)
                    case 'x'
                        tmp = reshape(tmp,[nx ny nz]);
                        data(cnt).value = tmp(n_slide,:,:);
                    case 'y'
                        tmp = reshape(tmp,[nx ny nz]);
                        data(cnt).value = tmp(:,n_slide,:);
                    case 'z'
                        tmp = reshape(tmp,[nx ny nz]);
                        data(cnt).value = tmp(:,:,n_slide);
                    otherwise
                        error('Invalid slides coordinate specified')
                end
            end
            cnt = cnt + 1;
        else
            fread(fid,nx*ny*nz,'double');
        end
    end
end

save(['./',filename,'.mat'],'nx','ny','nz','nvar','dt','time','data')
% save('./data.mat','nx','ny','nz','nvar','dt','time','data')
fclose(fid);