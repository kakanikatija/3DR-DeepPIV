clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
nFrames=finish-start;

display('Applying dataset-specific image operations')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEunwarp.mat'];
display('     Loading post-processed image stack...');
load(im_filenew);
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEfinal.mat'];
display('     Loading IMAGEfinal...');
load(im_filenew);

for i=160:1:size(IMAGEfinal,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEunwarp(:,:,i);
        imfinal=IMAGEfinal(:,:,i);
        figure(1)
        imshowpair(im,imfinal)
        n=input('Next image: Do you need to manually fill? no = [enter], yes = 0 ');
        while n==0
            imfinal=imfillmanual(im,imfinal);
            n=input('Do you need to manually fill? no = [enter], yes = 0 ');
        end
        clear n
        IMAGEfinal(:,:,i)=imfinal;
    end
	save(im_filenew,'IMAGEfinal','-v7.3');        %save post-processing parameters
