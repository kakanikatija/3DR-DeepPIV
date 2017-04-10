  clc;clear;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER INPUT REQUIRED BELOW
dataset='150601_batho';
vel=10; %mm/s %UNKNOWN
inc=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%e

dir='/users/kakani/desktop/';
imdir=[dir,'3DR/'];
tif='.tif';

%retrieving data set-specific parameters
[start,finish,fps,fstop,shutter,calib]=videoinfo(dataset,vel);

%retrieving smoothed image stack data
im_file=[imdir,dataset,'_IMAGEsm.mat'];
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
skip=2;
for i=1:1:size(IMAGEsm,3)-skip
    fixed=IMAGEsm(:,:,i);
    moving=IMAGEsm(:,:,i+skip);
%     figure(1)
%     imshowpair(fixed, moving,'falsecolor')
%     pause(0.1)
    tform = imregtform(moving, fixed, 'rigid', optimizer, metric);
    movingtform = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
%     figure(2)
%     imshowpair(fixed, movingtform,'falsecolor');
%     pause(0.1)
    IMAGEtform(:,:,i+1)=movingtform;
end
comparison=[IMAGEsm,IMAGEtform];
figure(3)
hfig=manipulate(comparison,output);  %define threshold and filter settings


% %plot isosurfaces
% figure(3)
% vals=1:10:255;
% hiso=patch(isosurface(X,Y,Z,IMAGEsm,2),'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
% isonormals(IMAGEsm,hiso)
% alpha(0.2)  %sets level of transparency
% view(3)
% camlight; lighting phong
% grid on
% daspect([1,1,5]);
% for i=1:1:size(vals,2)
%     id=vals(i);
%     [faces,vertices]=isosurface(X,Y,Z,IMAGEsm,id);
%     set(hiso,'Faces',faces,'Vertices',vertices);
%     pause(0.1);
% end

% figure(4)
% vals=0:100:3000;
% h=slice(X,Y,Z,IMAGEsm,[],[],vals(1));
% axis([0,800,0,800,0,3500]);
% colorbar
% for i=1:1:size(vals,2)
%     id=vals(i);
%     delete(h);
%     h=slice(X,Y,Z,IMAGEsm,[],[],id);
%     axis([0,800,0,800,0,3500]);
%     colorbar;
%     pause(0.1);
% end

% im_file=[imdir,dataset,'_IMAGEout.dcm'];
% dicomwrite(IMAGEout,out_file,'Endian','Big');