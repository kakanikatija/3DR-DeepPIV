clc; clear; close all;
tic
dataset='Part1';
val=10;
vel=10; %mm/s
inc=1;

%retrieving data set-specific parameters
[dir,~,~,~,~,~,calib,~,~,~]=videoinfo(dataset,vel);
outdir=[dir,'output/'];
meshdir=[dir,'meshlab/'];

%% loading stl file
bodyfile=[meshdir,'Part1.stl'];
outfile=[outdir,dataset,'_',num2str(val),'val_calib.mat'];
outstl=[meshdir,dataset,'_',num2str(val),'val_calib.stl'];

%% loading image stack and data
display('Loading smoothed image stack and other data files')
fv=stlread(bodyfile);

clear indir meshdir outdir viddir im_filenew filtfile bodyfile filtoutfile par_file
%% applying the calibration
fvnew=fv;
display('Plotting STL mesh');
fvnew=fv;
fvnew.vertices(:,1)=fv.vertices(:,1)*calib;
fvnew.vertices(:,2)=fv.vertices(:,2)*calib;
fvnew.vertices(:,3)=fv.vertices(:,3)*calib;

%% plotting stl mesh
h=figure(1);
set(h,'Position',[100,100,1500,1500]);
view(3)
camlight
lighting gouraud
% lighting none
grid on
daspect([1 1 1]);
hisobody=patch(fvnew,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6);
% hisobody=patch(fv,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6);

%% saving new stl file
hiso=[hisobody];
save(outfile,'hiso');
stlwrite(outstl,fvnew);