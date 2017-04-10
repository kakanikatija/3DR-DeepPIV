clc; clear; close all;
tic
dataset='151205_SC1ATK67_Batho_4';
val=10;
vel=10; %mm/s
% percent=0.05;
inc=1;

%retrieving data set-specific parameters
[dir,~,~,~,~,~,calib,~,~,~]=videoinfo(dataset,vel);
% dir=dir(13:end);
indir=[dir,'input/'];
outdir=[dir,'output/'];
im_file=[indir,dataset,'_IMAGEcrop.mat'];    %for position vector

%% Batho_small
% bodyfile=[outdir,'small_body_1_7711_aspectratio.stl'];
% innerfile=[outdir,'small_inner_1_7711_clean_aspectratio.stl'];
% outerfile=[outdir,'small_outer_1_7711_clean_aspectratio.stl'];
%% Batho med
% bodyfile=[outdir,'med_1val_body_7711sm_aspectratio.stl'];
% innerfile=[outdir,'med_1val_inner_7711sm_aspectratio.stl'];
% outerfile=[outdir,'med_1val_outer_7711sm_aspectratio.stl'];
%% Batho xlarge
% bodyfile=[outdir,'xlarge_5val_body_clean_7711sm_aspectratio.stl'];
% innerfile=[outdir,'xlarge_5val_filt_clean_7711sm_aspectratio.stl'];
%% Desmophyes
% bodyfile=[outdir,'Desmophyes_9_10val_clean_7711sm_aspectratio.stl'];
%% Larvacean
bodyfile=[outdir,'Batho_4_10val_body_clean_6611sm_aspectratio.stl'];

outvideo=[outdir,'videos/',dataset,'_',num2str(val),'val_all.mp4'];
outfile=[outdir,dataset,'_',num2str(val),'val_all-hiso.mat'];

%% loading image stack and data
display('Loading smoothed image stack and other data files')
load(im_file);
body=stlread(bodyfile);
% inner=stlread(innerfile);
% outer=stlread(outerfile);

clear indir meshdir outdir viddir im_filenew filtfile bodyfile filtoutfile par_file
%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(1);
set(h,'Position',[100,100,1500,1500]);
view(3)
camlight
lighting gouraud
% lighting none
grid on
daspect([1 1 1]);

display('Loading body mesh...')
hisobody=patch(body,'FaceColor',[0.5,0.5,0.5],'EdgeColor','none','FaceAlpha',0.6);
% display('Loading body mesh...')
% hisobody=patch(body,'FaceColor',[0.2,0.2,0.2],'EdgeColor','none','FaceAlpha',0.6);
% display('Loading inner filter mesh...')
% hisoinner=patch(inner,'FaceColor',[0.6,0.6,0.6],'EdgeColor','none','FaceAlpha',0.4);
% display('Loading outer filter mesh...')
% hisoouter=patch(outer,'FaceColor',[0.8,0.8,0.8],'EdgeColor','none','FaceAlpha',0.2);

%%
hiso=[hisobody];
% hiso=[hisobody;hisoinner];
% hiso=[hisobody;hisoinner;hisoouter];
save(outfile,'hiso');

%% saving rotating movie
display(['Saving 3DR movie with val = ',num2str(val)],'...');
% if exist(outfile,'file')==2
%     return
% else
    makevideo(outvideo);
% end
clear hisoinner hisobody hisoouter IMAGEcrop hiso
toc