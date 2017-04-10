clc;clear;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER INPUT REQUIRED BELOW
dataset='60p_f13_250sh';
vel=0; %mm/s
inc=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%

dir='/users/kakani/desktop/';
imdir=[dir,dataset,'/'];
tif='.tif';

%retrieving data set-specific parameters
[start,finish,fps,fstop,shutter,calib]=videoinfo(dataset,vel);

%arranging planar cross sections into "volume" matrix
for i=start:inc:finish
    imfile=[imdir,dataset,'_',num2str(i,'%3.4d'),tif];
    im=imread(imfile);
    imgray=rgb2gray(im);
    IMAGE(:,:,(i-start)/inc+1)=imgray;
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
end

%post-process all cross section images
IMAGEnew=postprocIM(IMAGE,output);  %crop, threshold, and filter images
IMAGEsm=smooth3(IMAGEnew);          %smooth images

%define physical domain
length=(finish-start)/fps*vel*calib;
[X,Y,Z]=meshgrid(1:size(IMAGEnew,2),1:size(IMAGEnew,1),1:length/size(IMAGEnew,3):length);

%plot contour slices
figure(2)
contourslice(X,Y,Z,IMAGEsm,[],[],[1:25/inc:max(max(max(Z)))],4);
view(3);
grid on
daspect([1,1,1]);

%plot isosurfaces
figure(3)
hiso=patch(isosurface(X,Y,Z,IMAGEsm,2),'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
isonormals(IMAGEsm,hiso)
alpha(0.3)  %sets level of transparency
view(3)
camlight
lighting gouraud
grid on
daspect([1,1,1]);