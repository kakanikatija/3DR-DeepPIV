  clc;clear;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER INPUT REQUIRED BELOW
dataset='150727_SC1ATK42_bathos_10';
dir='/Users/kakani/Desktop/150727_RachelCarson_DeepPIV/';
vel=10; %mm/s %UNKNOWN
inc=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%e

viddir=[dir,'clips/'];

%retrieving data set-specific parameters
[start,finish,fps,fstop,shutter,calib]=videoinfo(dataset,vel);

%retrieving smoothed image stack data
im_file=[viddir,dataset,'_IMAGEsm.mat'];
if exist(im_file,'file')==2
   load(im_file);
else
    display('Warning: Cannot find smoothed image stack');
    break
end

%define physical domain
length=(finish-start)/fps*vel*calib;
[X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:length/size(IMAGEsm,3):length);

[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

IMAGEtform=IMAGEsm(:,:,1);
skip=1;
for i=1:1:size(IMAGEsm,3)-skip
    if i==1
        fixed=IMAGEsm(:,:,i);
    else
        fixed=movingtform;
    end
    moving=IMAGEsm(:,:,i+skip);
%     figure(1)
%     imshowpair(fixed, moving,'falsecolor')
%     pause(0.1)
    tform = imregtform(moving, fixed, 'rigid', optimizer, metric);
    movingtform = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
%     figure(2)
%     imshowpair(fixed, movingtform,'falsecolor');
%     pause(0.1)
    IMAGEtform(:,:,i+skip)=movingtform;
end

%%
for i=1:1:size(IMAGEtform,3)
    combined=[IMAGEsm(:,:,i),IMAGEtform(:,:,i)];
    imshow(combined)
    pause(0.1)
end

% im_file=[imdir,dataset,'_IMAGEout.dcm'];
% dicomwrite(IMAGEout,out_file,'Endian','Big');