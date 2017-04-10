clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_med';
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

% preim_file=[indir,dataset,'_IMAGEprebody'];
% im_file=[indir,dataset,'_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_MASKbody.mat'];
im_file=[indir,dataset,'_IMAGEcrop.mat'];
im_body=[indir,dataset,'_IMAGEbodyCorrected.mat'];
mask_body=[indir,dataset,'_MASKbodyCorrected.mat'];
im_out=[indir,dataset,'_IMAGEhouse.mat'];
mask_out=[indir,dataset,'_MASKhouse.mat'];
if exist(im_file,'file')==2 && exist(im_out,'file')==2
    display('     Filtered image stack already exists.')
    return
elseif exist(im_file,'file')==2 && exist(im_out,'file')==0    
    display('     Loading IMAGE stacks...');
    load(im_file);
%     load(im_body);
    load(mask_body);
else
    display('     Cropped image stack does not exist. Run DeepPIV_3DR_batch.m.')
    break
end

%% extract filter features automatically
display('Extracting filter features automatically')
    IMAGEfilter=IMAGEcrop.*0;
    MASKfilter=IMAGEcrop.*0;
    
    for i=1:1:size(IMAGEcrop,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEcrop(:,:,i);
%         imbody=IMAGEbody(:,:,i);
        maskbody=MASKbody(:,:,i);
        im=im.*uint8(imcomplement(logical(maskbody)));
        [imnew,mask] = imoperations(im,dataset,contrast);
        figure(2)
%         imshow([im,imnew]);
        imshow([im,mask*255]);
    	text(100,100,['frame #: ',num2str(i)],'Color','w','FontSize',18)
        pause(0.1)
        IMAGEfilter(:,:,i)=imnew;
        MASKfilter(:,:,i)=mask;
        clear index
    end
save(im_out,'IMAGEfilter','-v7.3');        %save post-processing parameters
save(mask_out,'MASKfilter','-v7.3');        %save post-processing parameters
