clc; clear; close all;tic;

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);

vel=10; %mm/s %UNKNOWN
inc=1;
%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio]=videoinfo(dataset,vel);
nFrames=finish-start;

display('Loading video')
viddir=[dir,'clips/'];
vid=VideoReader([viddir,dataset,'.mov']);

%% arranging planar cross sections into "volume" matrix
if red==1
	display('Arranging images into a stack using the red color channel only');
else
    display('Arranging images into a stack using grayscale of images');
end
im_file=[viddir,dataset,'_IMAGE.mat'];
if exist(im_file,'file')==2
    load(im_file);                 %if exists, load original image stack
else
    im=read(vid,1)*0;
    IMAGE(:,:,(finish-start)/inc)=im;
    for i=start:inc:finish
        im=read(vid,i);
        if red==1
            IMAGE(:,:,(i-start)/inc+1)=im(:,:,1);
        else
            imgray=rgb2gray(im);
            IMAGE(:,:,(i-start)/inc+1)=imgray;
        end
    end
    save(im_file,'IMAGE','-v7.3');        %save post-processing parameters
end
close all; clear vid
pause(0.1)

%% retrieving/determining data set-specific post-processing parameters
display('Post-processing images')
par_file=[viddir,dataset,'_',num2str(vel),'vel_params.mat'];
if exist(par_file,'file')==2
    load(par_file);                 %if exists, load post-proc parameters
else
    hfig=crop_new(IMAGE);               %define cropped boundaries on image
    waitfor(hfig);
    hfig=manipulate_new(IMAGE,output);  %define threshold and filter settings
    waitfor(hfig);
    save(par_file,'output');        %save post-processing parameters
end
close all
pause(0.1)

%% post-process all cross section images
display('Saving post-processed image stack')
im_filenew=[viddir,dataset,'_IMAGEcrop.mat'];
if exist(im_filenew,'file')==2
    load(im_filenew);
else
    IMAGEcrop=postprocIM(IMAGE,output);  %crop, threshold, and filter images
    save(im_filenew,'IMAGEcrop','-v7.3');        %save post-processing parameters
end
close all; clear IMAGE; pause(0.1)
%%
display('Saving post-processed image stack')
im_filenew=[viddir,dataset,'_IMAGEsm.mat'];
if exist(im_filenew,'file')==2
    load(im_filenew);
else
    IMAGEsm=smooth3(IMAGEcrop);          %smooth images
    save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
end
close all; clear('IMAGEcrop','IMAGEnew'); pause(0.1)


%% plotting 3D reconstruction
display('Plotting image stack using isosurfaces')
%define physical domain
%%NEED TO CORRECT THIS SOON!
% length=(finish-start)/fps*vel*calib;
% [X,Y,Z]=meshgrid((1:size(IMAGEsm,2))/calib,(1:size(IMAGEsm,1))/calib,1:length/size(IMAGEsm,3):length);
[X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
xx=single(X);yy=single(Y);zz=single(Z);
clear X Y Z; pause(0.1)

%plot isosurfaces
figure(3)
val=10;
display(['Plotting isosurface with val = ',num2str(val)]);
hiso=patch(isosurface(xx,yy,zz,IMAGEsm,val,'verbose'),'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
isonormals(IMAGEsm,hiso)
alpha(0.2)  %sets level of transparency
view(3)
camlight
lighting gouraud
grid on
daspect(aspectratio);
% axis equal
outfile=[viddir,dataset,'_3DR_raw_',num2str(val),'.mp4'];
display(['Saving 3DR movie with val = ',num2str(val)]);
makevideo(outfile);
toc;