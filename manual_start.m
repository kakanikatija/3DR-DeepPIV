clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_medlarge';
vel=10;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
indir=[dir,'input/'];
nFrames=finish-start;

%% loading cropped image stack
display('Loading cropped image stack')
im_file=[indir,dataset,'_IMAGEcrop.mat'];
load(im_file)

for i=1:1:size(IMAGEcrop,3)
    display(['frame number: ',num2str(i)]);
    imshow(IMAGEcrop(:,:,i))
    pause(0.5)
end