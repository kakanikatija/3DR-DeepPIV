clc; clear; close all; warning('off');tic

dataset='151202_SC1ATK64_Desmophyes_9';
display(dataset);

val=1;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
dir=dir(13:end);
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
nFrames=finish-start;

%% extract body features manually
display('Extracting body features manually')
% preim_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEcrop.mat'];
% im_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_',num2str(vel),'vel_MASKbody.mat'];
preim_file=[indir,dataset,'_IMAGEcrop.mat'];
im_file=[indir,dataset,'_IMAGEbody.mat'];
mask_file=[indir,dataset,'_MASKbody.mat'];
im_out=[indir,dataset,'_IMAGEbodyCorr.mat'];
mask_out=[indir,dataset,'_MASKbodyCorr.mat'];
% im_file=[indir,dataset,'_',num2str(val),'val_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_',num2str(val),'val_MASKbody.mat'];
% im_out=[indir,dataset,'_',num2str(val),'val_IMAGEbodyCorrected.mat'];
% mask_out=[indir,dataset,'_',num2str(val),'val_MASKbodyCorrected.mat'];

if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(preim_file);
    load(im_file);
    load(mask_file);
    IMAGEbody=IMAGEfilter; 
    MASKbody=MASKfilter;
%     load(im_out)
%     load(mask_out)
    clear('IMAGEfilter','MASKfilter')
else
    display('     Body location is not extracted. Run DeepPIV_3DR_AutoBodyFilter_160322.m.')
    break
end
%%
for i=1:1:size(IMAGEcrop,3)
    display(['frame number: ',num2str(i)]); 
    im=IMAGEcrop(:,:,i);
	imnew=imadjust(im,[0,0.5],[0,1]);
    imfinal=IMAGEbody(:,:,i);
    mask=MASKbody(:,:,i);
    figure(1)
%     imshowpair(imadjust(im,[0,0.5],[0,1]),mask*255);
    imshow(logical(mask))
	n=input('Next image: Do you need to manually remove? no = [enter], yes = 0 ');
%     n=0;
    if isempty(n)==1
        masknew=mask;
    end
    while n==0
%         [imfinal,masknew]=bodyremovemanual(im,imfinal,mask);
        [imfinal,masknew]=bodyremoveblobs(im,imfinal,mask);
        n=input('Do you need to manually remove? no = [enter], yes = 0 ');
    end
    clear n
  	masknew=uint8(imfill(logical(masknew),'holes'));
	imfinal=imnew.*masknew;
    IMAGEbody(:,:,i)=imfinal;
    MASKbody(:,:,i)=masknew;
end
save(im_out,'IMAGEbody','-v7.3');        %save post-processing parameters
save(mask_out,'MASKbody','-v7.3');        %save post-processing parameters