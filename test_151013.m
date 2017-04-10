clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);
add=1;

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
preim_file=[indir,dataset,'_IMAGEprebody'];
maskbody_file=[indir,dataset,'_MASKbody.mat'];
im_file=[indir,dataset,'_IMAGEfilter.mat'];
mask_file=[indir,dataset,'_MASKfilter.mat'];
im_out=[indir,dataset,'_IMAGEfilternew.mat'];
mask_out=[indir,dataset,'_MASKfilternew.mat'];

if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(preim_file);
    load(im_file);
    load(maskbody_file)
    load(mask_file);
else
    display('     Body points are not extracted. Run DeepPIV_3DR_ManualBody.m.')
    break
end

IMAGEfilternew=IMAGEfilter;
MASKfilternew=MASKfilter;
% clear IMAGEfilter MASKfilter
%%
for i=1:1:size(IMAGEprebody,3)
    display(['frame number: ',num2str(i)]);
    im=IMAGEprebody(:,:,i);
    imfinal=IMAGEfilternew(:,:,i);
    if size(MASKfilternew,3)<i
        mask=im.*0;
    else
        mask=MASKfilternew(:,:,i);
    end
    maskbody=MASK(:,:,i);
    mask=bwareaopen(bwmorph(bwmorph(bwmorph(bwmorph(adapthisteq(IMAGEprebody(:,:,i),'NumTiles',[2,2])>50,'bridge'),'close'),'erode'),'clean'),15);
    
    figure(1)
    imshowpair(imfinal,imfinal.*uint8(mask))
    text(100,100,['frame #: ',num2str(i)],'Color','w','FontSize',18)
    pause(0.1)
    imfinal=imfinal.*uint8(mask);
    IMAGEfilternew(:,:,i)=imfinal;
    MASKfilternew(:,:,i)=mask;
end
save(im_out,'IMAGEfilternew','-v7.3');        %save post-processing parameters
save(mask_out,'MASKfilternew','-v7.3');        %save post-processing parameters

