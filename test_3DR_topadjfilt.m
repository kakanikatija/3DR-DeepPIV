clc; clear; close all; warning('off');

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

%% post-process all cross section images
display('Saving post-processed image stack')
im_filenew=[viddir,dataset,'_IMAGEcrop.mat'];
if exist(im_filenew,'file')==2
    load(im_filenew);
else
    IMAGEcrop=postprocIM(IMAGE,output);  %crop, threshold, and filter images
    save(im_filenew,'IMAGEcrop','-v7.3');        %save post-processing parameters
end
close all; clear IMAGE
%%
display('Saving post-processed image stack')
im_filenew=[viddir,dataset,'_IMAGEsm.mat'];
if exist(im_filenew,'file')==2
    load(im_filenew);
else
    im=IMAGEcrop(:,:,1)*0;imtop=im;imdil=im;imadj=im;imbin=im;imero=im;imnew=im;
    IMAGEnew=IMAGEcrop*0;
    for i=1:1:size(IMAGEcrop,3)
        im=IMAGEcrop(:,:,i);
        imtop = imtophat(im,strel('disk',15));
        imadj=imadjust(imtop,[0.08,0.39],[]);%using low and high limits provides absolute values for image adjustments
        imfilt=medfilt2(imadj,[5,5]);
        figure(1)
        imshow([im,imtop;imadj,imfilt])
        width=size(im,2);height=size(im,1);
        text(width*0.5,20,'im','Color','w','FontSize',16);text(width*1.5,20,'imtop','Color','w','FontSize',16);
        text(width*0.5,height,'imadj','Color','w','FontSize',16);text(width*1.5,height,'imfilt','Color','w','FontSize',16);        
        
        imdil=imdilate(imadj,strel('disk',10));
        imbin=im2bw(imdil,0.3);
%         figure(2)
%         imshow([im;imdil;imbin*255])
%         imdil=imdilate(imbin,strel('rectangle',[2,4]));
        imfilled=imfill(imbin,'holes');
        imopen=bwareaopen(imfilled,1500,4);
        figure(2)
        imshow([imbin*255,imdil*255;imfilled*255,imopen*255])
       	text(width*0.5,20,'imbin','Color','w','FontSize',16);text(width*1.5,20,'imdil','Color','w','FontSize',16);
        text(width*0.5,height,'imfilled','Color','w','FontSize',16);text(width*1.5,height,'imopen','Color','w','FontSize',16);
        imnew=imfilt.*uint8(imopen);
        figure(3)
        imshow([im,imnew])
       	text(width*0.5,20,'im','Color','w','FontSize',16);text(width*1.5,20,'imnew','Color','w','FontSize',16);
        IMAGEnew(:,:,i)=imnew;
    end
    IMAGEsm=smooth3(IMAGEnew);          %smooth images
    save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
end
close all; clear('IMAGEcrop','IMAGEnew')


%% plotting 3D reconstruction
display('Plotting image stack using isosurfaces')
%define physical domain
%%NEED TO CORRECT THIS SOON!
% length=(finish-start)/fps*vel*calib;
% [X,Y,Z]=meshgrid((1:size(IMAGEsm,2))/calib,(1:size(IMAGEsm,1))/calib,1:length/size(IMAGEsm,3):length);
[X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
xx=single(X);yy=single(Y);zz=single(Z);
clear X Y Z

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
outfile=[viddir,dataset,'_3DR_topadjfilt_',num2str(val),'.mp4'];
display(['Saving 3DR movie with val = ',num2str(val)]);
makevideo(outfile);