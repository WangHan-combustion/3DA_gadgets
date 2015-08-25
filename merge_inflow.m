function merge_inflow(inflow_dir,suffix)
files = dir([inflow_dir,'/',suffix,'*']);

buf = cell(1,length(files));
for ii = 1:length(files)
    buf{ii} = load(files(ii).name);
end

dims = buf{1}.dims;
inflow_freq = buf{1}.inflow_freq;
time = buf{1}.time;
data = buf{1}.data;
icyl = buf{1}.icyl;
y = buf{1}.y;
z = buf{1}.z;

for ii = 2:length(files)
    for var = 1:length(data)
        data(var).value(:,:,dims(1)+1:dims(1)+buf{ii}.dims(1)) = buf{ii}.data(var).value;
    end
    dims(1) = dims(1)+buf{ii}.dims(1);
end

save(suffix,'dims','inflow_freq','time','data','icyl','y','z','-v7.3')