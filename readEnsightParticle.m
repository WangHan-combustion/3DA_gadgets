function readEnsightParticle(part_path,nskip)

part_dir = dir(part_path);
nfile = length(part_dir)-2;

nstep = nfile/5;

for iFile = 1:nskip:nstep
    % coordinates
    filename1 = [part_path,'/particles.',num2str(iFile,'%6.6i')];
    fid1 = fopen(filename1,'r');
    fread(fid1,80,'char*1');
    fread(fid1,80,'char*1');
    fread(fid1,80,'char*1');
    npart = fread(fid1,1,'integer*4');
    fread(fid1,npart,'integer*4');
    % diameter
    filename2 = [part_path,'/diameter.',num2str(iFile,'%6.6i')];
    fid2 = fopen(filename2,'r');
    fread(fid2,80,'char*1');
    % temperature
    filename3 = [part_path,'/temperature.',num2str(iFile,'%6.6i')];
    fid3 = fopen(filename3,'r');
    fread(fid3,80,'char*1');
    % temperature
    filename4 = [part_path,'/density.',num2str(iFile,'%6.6i')];
    fid4 = fopen(filename4,'r');
    fread(fid4,80,'char*1');
    % velocity
    filename5 = [part_path,'/velocity.',num2str(iFile,'%6.6i')];
    fid5 = fopen(filename5,'r');
    fread(fid5,80,'char*1');
    
    for ipart = 1:npart
        % x
        data_part{iFile}.value(ipart,1) = fread(fid1,1,'real*4');
        % y
        data_part{iFile}.value(ipart,2) = fread(fid1,1,'real*4');
        % z
        data_part{iFile}.value(ipart,3) = fread(fid1,1,'real*4');
        % diameter
        data_part{iFile}.value(ipart,4) = fread(fid2,1,'real*4');
        % temperature
        data_part{iFile}.value(ipart,5) = fread(fid3,1,'real*4');
        % density
        data_part{iFile}.value(ipart,6) = fread(fid4,1,'real*4');
        % u
        data_part{iFile}.value(ipart,7) = fread(fid5,1,'real*4');
        % v
        data_part{iFile}.value(ipart,8) = fread(fid5,1,'real*4');
        % w
        data_part{iFile}.value(ipart,9) = fread(fid5,1,'real*4');
    end
    fclose(fid1);
    fclose(fid2);
    fclose(fid3);
    fclose(fid4);
    fclose(fid5);
end

save('./data_part.mat','data_part');