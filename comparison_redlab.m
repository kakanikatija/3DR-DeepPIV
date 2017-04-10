tic
clc; clear; close all;
dataset='150811_DeepPIV_BathoStyg_3DR_small';

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05;
inc=1;
%retrieving data set-specific parameters
% [dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo_MBP(dataset,vel);
outdir=[dir,'output/'];

%% cropped image stack
display('Loading cropped image stack')
im_filelab=[outdir,dataset,'_IMAGEcroplab.mat'];
im_filered=[outdir,dataset,'_IMAGEcropred.mat'];
load(im_filelab);load(im_filered);

%% unwarping all images in stack
display('Unwarping all images in stack')
im_filenew=[outdir,dataset,'_',num2str(vel),'vel_IMAGEunwarplab.mat'];
if exist(im_filenew,'file')==2
    load(im_filenew);
else
    [optimizer, metric]  = imregconfig('monomodal');
    im1=IMAGEcropred(:,:,1);%makethemstoptalkingplease
    IMAGEunwarplab=IMAGEcroplab;
    IMAGEunwarpred=IMAGEcropred;
    for i=1:1:size(IMAGEcropred,3)-1
        im2=IMAGEcropred(:,:,i+1);
        tform=imregtform(im2,im1,'rigid',optimizer,metric);
        rot=asin(tform.T(1,1));%xdisp=tform.T(3,1);ydisp=tform.T(3,2);
        if i>1
            rot2=asin(tform2.T(1,1));%xdisp2=tform2.T(3,1);ydisp2=tform2.T(3,2);
            if abs(rot-rot2)/abs(rot2)>percent %|| abs(xdisp-xdisp2)/max(abs([xdisp,xdisp2]))>percent || abs(ydisp-ydisp2)/max(abs([ydisp,ydisp2]))>percent
                tform=tform2;
            end
        end
        newim2 = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
        IMAGEunwarpred(:,:,i+1)=newim2;
        im1=newim2;
        tform2=tform;
    end
    save(im_filenew,'IMAGEunwarp','-v7.3');
end
clear im1 im2 newim2 tform optimizer metric im_filenew IMAGEcrop

%% post-process all cross section images
display('Smoothing between planes of image stack')
im_filelab=[outdir,dataset,'_IMAGEsmlab.mat'];
im_filered=[outdir,dataset,'_IMAGEsmred.mat'];
IMAGEsmlab=smooth3(IMAGEcroplab);          %smooth images
save(im_filelab,'IMAGEsmlab','-v7.3');        %save post-processing parameters
clear IMAGEcroplab
IMAGEsmred=smooth3(IMAGEcropred);          %smooth images
save(im_filered,'IMAGEsmred','-v7.3');        %save post-processing parameters
close all; clear IMAGEcropred
load(im_filered)

% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1000,1000]);
outdatalab=[outdir,dataset,'_hiso-lab_',num2str(val),'.mat'];
outdatared=[outdir,dataset,'_hiso-red_',num2str(val),'.mat'];
[X,Y,Z]=meshgrid(1:size(IMAGEsmlab,2),1:size(IMAGEsmlab,1),1:size(IMAGEsmlab,3));
[X,Y,Z]=meshgrid(1:size(IMAGEsmred,2),1:size(IMAGEsmred,1),1:size(IMAGEsmred,3));
newaspect=aspectratio/aspectratio(1,1);
xx=single(X)/newaspect(1);yy=single(Y)/newaspect(2);zz=single(Z)/newaspect(3);
clear X Y Z
fv=isosurface(xx,yy,zz,IMAGEsmlab,val,'verbose');
outstl=[outdir,dataset,'_lab',num2str(val),'.stl'];
stlwrite(outstl,fv);
hiso=patch(fv,'FachieColor',[0.5,0.5,0.65],'EdgeColor','none');
save(outdatalab,'hiso');
fv=isosurface(xx,yy,zz,IMAGEsmred,val,'verbose');
clear xx yy zz
outstl=[outdir,dataset,'_red',num2str(val),'.stl'];
stlwrite(outstl,fv);
hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
save(outdatared,'hiso');
clear fv hiso