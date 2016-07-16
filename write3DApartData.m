function write3DApartData(data,filename,version)
fid = fopen(filename,'w');
fwrite(fid,data.npart,'integer*4');
fwrite(fid,data.part_size,'integer*4');
fwrite(fid,data.dt,'real*8');
fwrite(fid,data.time,'real*8');
switch version
    case 'FlameMaster 3DA'
        for ipart = 1:npart
            fwrite(fid,data.part(ipart,1:15),'real*8');
            fwrite(fid,data.part(ipart,16:length(data.ref)),'integer*4');
        end
    case 'Chemkin 3DA'
        max_comp = size(data.part,2);
        for ipart = 1:npart
                fwrite(fid,data.part(ipart,1:7),'real*8');
                fwrite(fid,data.mk(ipart,1:max_comp),'real*8');
                fwrite(fid,data.part(ipart,8:15),'real*8');
                fwrite(fid,data.part(ipart,16:length(ref)),'integer*4');
        end
end
fclose(fid);
return