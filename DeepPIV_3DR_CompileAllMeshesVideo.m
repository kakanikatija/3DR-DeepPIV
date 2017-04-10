clc; clear; close all;
tic
dataset='151202_SC1ATK64_EggMass_2';
val=5;
vel=10; %mm/s
percent=0.05;
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,~,~,~,calib,~,~,contrast]=videoinfo(dataset,vel);

viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
meshdir=[dir,'meshlab/'];
par_file=[indir,dataset,'_',num2str(vel),'vel_params.mat'];
images=[indir,dataset,'_IMAGEfiltersm.mat'];
mesh1=[outdir,dataset,'_',num2str(val),'val_eggs_7711.stl'];
mesh2=[outdir,dataset,'_',num2str(val),'val_exterior_7711.stl'];

outfile=[outdir,dataset,'_',num2str(val),'val_allmeshes.mp4'];

%% loading image stack and data
display('Loading meshes')
load(images)
m1=stlread(mesh1);
m2=stlread(mesh2);

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(1);
set(h,'Position',[100,100,1000,1000]);

display('Computing body mesh...')

hiso1=patch(m1,'FaceColor',[0.2,0.2,0.2],'EdgeColor','none','FaceAlpha',0.6);
% isonormals(IMAGEsm,hiso1)
% alpha(0.6)  %sets level of transparency
display('Computing inner filter mesh...')
hiso2=patch(m2,'FaceColor',[0.6,0.6,0.6],'EdgeColor','none','FaceAlpha',0.2);
% isonormals(IMAGEsm,hiso2)
% alpha(0.4)  %sets level of transparency
% display('Computing outer filter mesh...')
% hisofiltout=patch(filtout,'FaceColor',[0.6,0.6,0.6],'EdgeColor','none','FaceAlpha',0.2);
% % isonormals(IMAGEsm,hisofiltout)
% % alpha(0.2)  %sets level of transparency

% hiso=[hisobody];
hiso=[hiso1;hiso2];
% hiso=[hisobody;hisofilt;hisofiltout];
% hold off
view(3)
camlight
lighting gouraud
grid on
daspect([1 1 1]);

%% saving rotating movie
display(['Saving 3DR movie with val = ',num2str(val)],'...');
% if exist(outfile,'file')==2
%     return
% else
    makevideo(outfile);
% end
clear hisofilt hisobody hisofiltout IMAGEsm 
toc