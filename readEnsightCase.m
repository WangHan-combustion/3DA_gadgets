function data = readEnsightCase(caseFileDirectory,nSkip,nx,ny,nz,nprocx,nprocy,nprocz)

root_dir = dir(caseFileDirectory);
root_dir = root_dir(3:end);                     % remove directory ./ and ../
% count number of variables
nVar = 0;
for iVar = 1:length(root_dir)
    if root_dir(iVar).isdir == 1
        nVar = nVar + 1;
        data(nVar).name = root_dir(iVar).name;
    end
end

% read each variables
for iVar = 1:nVar
    % Start timer
    timer = tic;
    
    cntFile = 1;
    var_path = [caseFileDirectory,data(iVar).name,'/'];
    var_dir = dir(var_path);
    var_dir = var_dir(3:end);
    nFile = length(var_dir);
    fprintf('Number of files: %2d\n',nFile);
    switch data(iVar).name
        case 'V'
            data(iVar).U = zeros(nx,ny,nz,floor(nFile/nSkip));
            data(iVar).V = zeros(nx,ny,nz,floor(nFile/nSkip));
            data(iVar).W = zeros(nx,ny,nz,floor(nFile/nSkip));
        otherwise
            data(iVar).value = zeros(nx,ny,nz,floor(nFile/nSkip));
    end
    
    for iFile=1:nSkip:nFile
        filename = [var_path,var_dir(iFile).name];
        fprintf(['Reading file: ',var_dir(iFile).name,'\n']);
        switch data(iVar).name
            case 'V'
                [U_tmp,V_tmp,W_tmp] = readensight_vector(filename,nx,ny,nz);
                data(iVar).U(:,:,:,cntFile) = reshape_field(U_tmp,nx,ny,nz,nprocx,nprocy,nprocz);
                data(iVar).V(:,:,:,cntFile) = reshape_field(V_tmp,nx,ny,nz,nprocx,nprocy,nprocz);
                data(iVar).W(:,:,:,cntFile) = reshape_field(W_tmp,nx,ny,nz,nprocx,nprocy,nprocz);
            otherwise
                tmp = readensight_scalar(filename,nx,ny,nz);
                data(iVar).value(:,:,:,cntFile) = reshape_field(tmp,nx,ny,nz,nprocx,nprocy,nprocz);
                cntFile = cntFile + 1;
        end
        
        fprintf(['Time taken for initializing ',data(iVar).name,': %15.7e\n'],toc(timer))
    end
end
fprintf('Initializing data complete\n')

%% 
function res = reshape_field(phi,Nx,Ny,Nz,NprocX,NprocY,NprocZ)
Xbloc = ones(1,NprocX)*floor(Nx/NprocX);
Ybloc = ones(1,NprocY)*floor(Ny/NprocY);
Zbloc = ones(1,NprocZ)*floor(Nz/NprocZ);

if mod(Nx,NprocX)~=0
    for ii = 1:mod(Nx,NprocX)
        Xbloc(ii) = Xbloc(ii)+1;
    end
end
if mod(Ny,NprocY)~=0
    for ii = 1:mod(Ny,NprocY)
        Ybloc(ii) = Ybloc(ii)+1;
    end
end
if mod(Nz,NprocZ)~=0
    for ii = 1:mod(Nz,NprocZ)
        Zbloc(ii) = Zbloc(ii)+1;
    end
end

phiInd = 0;
XblocInd = 0;
YblocInd = 0;
ZblocInd = 0;

res = zeros(Nx,Ny,Nz);

% Sequence: %z-y-x
for ii = 1:NprocX
    for jj = 1:NprocY
        for kk = 1:NprocZ
            Nbloc = Xbloc(ii)*Ybloc(jj)*Zbloc(kk);
            res(XblocInd+1:XblocInd+Xbloc(ii),YblocInd+1:YblocInd+Ybloc(jj),ZblocInd+1:ZblocInd+Zbloc(kk)) = ...
                reshape_bloc(phi(phiInd+1:phiInd+Nbloc),Xbloc(ii),Ybloc(jj),Zbloc(kk));
            phiInd = phiInd + Nbloc;
            
            ZblocInd = ZblocInd + Zbloc(kk);
%             fprintf('%5i %5i %5i\n',Xbloc(ii),Ybloc(jj),Zbloc(kk))
%             fprintf('%4i %4i %4i %5i %5i %5i %10i\n',ii,jj,kk,XblocInd,YblocInd,ZblocInd,phiInd)
        end
        YblocInd = YblocInd + Ybloc(jj);
        ZblocInd = 0;
    end
    XblocInd = XblocInd + Xbloc(ii);
    YblocInd = 0;
end

%%
function res = reshape_bloc(phi,Nx,Ny,Nz)
res = zeros(Nx,Ny,Nz);
for kk = 1:Nz
    for jj = 1:Ny
        for ii = 1:Nx
            ind = (kk-1)*Nx*Ny+(jj-1)*Nx+ii;
            res(ii,jj,kk) = phi(ind);
        end
    end
end

%% READ ENSIGHT FILE
function [var1,var2,var3]=readensight_vector(filename,nx,ny,nz)


% OPEN THE FILE
fid=fopen(filename);

% SKIP THE USELESS HEADER

fread(fid,80,'char*1');
fread(fid,80,'char*1');
fread(fid,1,'int');
fread(fid,80,'char*1');

%load the data file 

var1=fread(fid,nx*ny*nz,'single');
var2=fread(fid,nx*ny*nz,'single');
var3=fread(fid,nx*ny*nz,'single');

fclose(fid);

%% READ ENSIGHT FILE
function var=readensight_scalar(filename,nx,ny,nz)


% OPEN THE FILE
fid=fopen(filename);

% SKIP THE USELESS HEADER

fread(fid,80,'char*1');
fread(fid,80,'char*1');
fread(fid,1,'int');
fread(fid,80,'char*1');

%load the data file 

var=fread(fid,nx*ny*nz,'single');

fclose(fid);

%% 
function [gradx,grady,gradz]=gradients_periodic(var,deltax,Nx)
for i=1:Nx
    for j=1:Nx
        for k=1:Nx
            ip1=mod(i-1+1,Nx)+1;
            im1=mod(i-1-1,Nx)+1;
            gradx(i,j,k)=(var(ip1,j,k)-var(im1,j,k))/(2*deltax);
            jp1=mod(j-1+1,Nx)+1;
            jm1=mod(j-1-1,Nx)+1;
            grady(i,j,k)=(var(i,jp1,k)-var(i,jm1,k))/(2*deltax);
            kp1=mod(k-1+1,Nx)+1;
            km1=mod(k-1-1,Nx)+1;
            gradz(i,j,k)=(var(i,j,kp1)-var(i,j,km1))/(2*deltax);
        end
    end
end