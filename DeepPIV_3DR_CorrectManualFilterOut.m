clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_small';
display(dataset);
add=0;

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
im_out=[indir,dataset,'_IMAGEfilterout.mat'];
mask_out=[indir,dataset,'_MASKfilterout.mat'];

if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(preim_file);
    load(im_file);
    load(maskbody_file)
    load(mask_file);
    load(im_out);
    load(mask_out);
else
    display('     Body points are not extracted. Run DeepPIV_3DR_ManualBody.m.')
    break
end

%%
for i=219:1:size(IMAGEprebody,3)
    display(['frame number: ',num2str(i)]);
    im=IMAGEprebody(:,:,i);
    imfinal=IMAGEout(:,:,i);
    if size(MASKout,3)<i
        mask=im.*0;
    else
        mask=MASKout(:,:,i);
    end
    maskbody=MASK(:,:,i);
    maskfilt=MASKfilter(:,:,i);
    masktot=max(maskbody,maskfilt);
    figure(1)
    imnew=imadjust(im,[0.05,0.5],[0,1]);
    imshowpair(imnew,imfinal);
	n=input('Next image: Do you need to manually adjust? no = [enter], yes = 0 ');
%     n=0;
    while n==0
        if add==1
            [imfinal,mask]=filterfillmanual(imnew,imfinal,mask,masktot);
            m=input('Do you need to fill mask? no [enter], yes [0] ');
            if m==0
                mask=imfill(mask);
                imfinal=imnew.*uint8(mask);
                imshow(imfinal)
            end
            n=input('Do you need to manually fill? no = [enter], yes = 0 ');
        else
            [imfinal,mask]=filterremovemanual(imnew,imfinal,mask,masktot);
            m=input('Do you need to fill mask? no [enter], yes [0] ');
            if m==0
                mask=imfill(mask);
                imfinal=imnew.*uint8(mask);
                imshow(imfinal)
            end
            n=input('Do you need to manually remove? no = [enter], yes = 0 ');
        end
    end
    clear n
    IMAGEout(:,:,i)=imfinal;
    MASKout(:,:,i)=mask;
end
    
save(im_out,'IMAGEout','-v7.3');        %save post-processing parameters
save(mask_out,'MASKout','-v7.3');        %save post-processing parameters

