function particle3DAtoTec(part_data,filename)
fid = fopen([filename,'.dat'],'w');
% print the name of variables
fprintf(fid,'variables = ');
for ii = 1:length(part_data.ref)
    fprintf(fid,['"',part_data.ref{ii},'" ']);
end
fprintf(fid,'\n');
% print the zone type
fprintf(fid,'zone t = "droplet"\n');
% print the data type
fprintf(fid,'f = point\n');
% print the data
n = size(part_data.part,1);
fprintf(fid,'i = %i, j = %i, k = %i\n',n,1,1);
for ii = 1:n
    for ivar = 1:length(part_data.ref)
        fprintf(fid,'%15.7f ',part_data.part(ii,ivar));
    end
    fprintf(fid,'\n');
end

fclose(fid);