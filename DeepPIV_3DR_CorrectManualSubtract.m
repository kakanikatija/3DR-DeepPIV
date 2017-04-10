clc; clear; close all; warning('off');tic

dataset='60p_f013_250sh';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
nFrames=finish-start;

%% extract body features manually
display('Extracting body features manually')
preim_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEprebody'];
im_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEbody.mat'];
mask_file=[indir,dataset,'_',num2str(vel),'vel_MASKbody.mat'];
% preim_file=[indir,dataset,'_IMAGEprebody'];
% im_file=[indir,dataset,'_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_MASKbody.mat'];
if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(preim_file);
    load(im_file);
    load(mask_file);
else
    display('     Body points are not extracted. Run DeepPIV_3DR_ManualBody.m.')
    break
end

%%
for i=1:1:size(IMAGEprebody,3)
    display(['frame number: ',num2str(i)]); 
    im=IMAGEprebody(:,:,i);
    imfinal=IMAGEbody(:,:,i);
    mask=MASK(:,:,i);
    figure(1)
    imshowpair(imadjust(im,[0,0.5],[0,1]),imfinal);
	n=input('Next image: Do you need to manually remove? no = [enter], yes = 0 ');
%     n=0;
    while n==0
        [imfinal,mask]=bodyremovemanual(im,imfinal,mask);
        n=input('Do you need to manually remove? no = [enter], yes = 0 ');
    end
    clear n
    IMAGEbody(:,:,i)=imfinal;
    MASK(:,:,i)=mask;
end
save(im_file,'IMAGEbody','-v7.3');        %save post-processing parameters
save(mask_file,'MASK','-v7.3');        %save post-processing parameters