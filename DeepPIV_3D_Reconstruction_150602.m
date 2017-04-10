 clc;clear;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER INPUT REQUIRED BELOW
dataset='150727_SC1ATK42_bathos_10';
dir='/Users/kakani/Desktop/150727_RachelCarson_DeepPIV/';
vel=10; %mm/s %UNKNOWN
inc=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%e

viddir=[dir,'clips/'];
vid=VideoReader([dir,dataset,'.mov']);

%retrieving data set-specific parameters
[start,finish,fps,fstop,shutter,calib]=videoinfo(dataset,vel);
nFrames=finish-start;

%arranging planar cross sections into "volume" matrix
for i=start:inc:finish
    im=read(vid,i);
%     imgray=rgb2gray(im);
%     IMAGE(:,:,(i-start)/inc+1)=imgray;
    IMAGE(:,:,(i-start)/inc+1)=im(:,:,1);
    figure(1)
    imshow(im)
    pause(0.1)
end

%retrieving/determining data set-specific post-processing parameters
par_file=[imdir,dataset,'_',num2str(vel),'vel_params.mat'];
if exist(par_file,'file')==2
    load(par_file);                 %if exists, load post-proc parameters
else
    hfig=crop(IMAGE);               %define cropped boundaries on image
    waitfor(hfig);
    hfig=manipulate(IMAGE,output);  %define threshold and filter settings
    waitfor(hfig);
    save(par_file,'output');        %save post-processing parameters
    close all
end

%post-process all cross section images
IMAGEnew=postprocIM(IMAGE,output);  %crop, threshold, and filter images
IMAGEsm=smooth3(IMAGEnew);          %smooth images

im_file=[imdir,dataset,'_IMAGEsm.mat'];
if exist(im_file,'file')==2
%     return
else
    save(im_file,'IMAGEsm');        %save post-processing parameters
    close all
end

%define physical domain
length=(finish-start)/fps*vel*calib;
[X,Y,Z]=meshgrid(1:size(IMAGEnew,2),1:size(IMAGEnew,1),1:length/size(IMAGEnew,3):length);

% %plot contour slices
% figure(2)
% contourslice(X,Y,Z,IMAGEsm,[],[],[1:25/inc:max(max(max(Z)))],4);
% view(3);
% grid on
% daspect([1,1,1]);

%plot isosurfaces
figure(3)
% maximize(3)
vals=1:10:255;
hiso=patch(isosurface(X,Y,Z,IMAGEsm,2),'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
isonormals(IMAGEsm,hiso)
alpha(0.2)  %sets level of transparency
view(3)
camlight
lighting gouraud
grid on
daspect([1,1,5]);

axis vis3d off
for j=1:1:2
    if j==1
        mov(j)=getframe;
    else
%         axis vis3d off
        for i=1:180
            camorbit(2,0,'camera')
            drawnow
            mov(j)=getframe;
            j=j+1;
        end
        for i=1:180
            camorbit(0,2,'camera')
            drawnow
            mov(j)=getframe;
            j=j+1;
        end
    end
end
outfile=[imdir,dataset,'_3DR.mp4'];
writerObj=VideoWriter(outfile,'MPEG-4');
open(writerObj);
writeVideo(writerObj,mov);
close(writerObj);