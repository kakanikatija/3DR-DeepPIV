dataset='60p_f13_250sh';
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
% im_file=[indir,dataset,'_IMAGEprebody.mat'];
% load(im_file);
% im_file=[indir,dataset,'_MASKbody.mat'];
% load(im_file)
preim_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEprebody'];
load(preim_file)
im_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEbody.mat'];
load(im_file)
mask_file=[indir,dataset,'_',num2str(vel),'vel_MASKbody.mat'];
load(mask_file)

IMAGEbody=IMAGEprebody.*0;
for i=1:1:size(IMAGEprebody,3)
    im=IMAGEprebody(:,:,i);
    mask=MASK(:,:,i);
    imfinal=imadjust(im,[0,0.5],[0,1]).*uint8(mask);
    IMAGEbody(:,:,i)=imfinal;
    imshow(imfinal)
    pause(0.1)
end
% im_filenew=[indir,dataset,'_IMAGEbody.mat'];
save(im_file,'IMAGEbody','-v7.3');        %save post-processing parameters
