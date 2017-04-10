clc; clear; close all;
tic
dataset='151202_SC1ATK64_Desmophyes_8';
val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05;
inc=1;
%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);

viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
par_file=[indir,dataset,'_params.mat'];
% im_filenew=[indir,dataset,'_IMAGEbodysm.mat'];
% hisofile=[outdir,dataset,'_hiso_body.mat'];
% stlfile=[outdir,dataset,'_body.stl'];
% outdata=[outdir,dataset,'_aspectratio.mat'];
% outstl=[outdir,dataset,'_aspectratio.stl'];
% outfile=[outdir,dataset,'_aspectratio.mp4'];

% im_filenew=[indir,dataset,'_',num2str(vel),'vel_IMAGEbodysm.mat'];
% hisofile=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_hiso_body.mat'];
% stlfile=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_body.stl'];
% outdata=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_hiso_aspectratio.mat'];
% outstl=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_aspectratio.stl'];
% outfile=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_aspectratio.mp4'];
% datasets
% im_filenew=[indir,dataset,'_IMAGEbodysm.mat'];
im_filenew=[indir,dataset,'_IMAGEfilter.mat'];
% hisofile=[outdir,dataset,'_hiso_',num2str(val),'.mat'];
hisofile=[outdir,dataset,'_', num2str(val),'val_hiso','.mat'];
stlfile=[outdir,dataset,'_',num2str(val),'val.stl'];
% stlfile=[outdir,'100_10val_cleaned.stl'];
outdata=[outdir,dataset,'_',num2str(val),'val_hiso_aspectratio.mat'];
outstl=[outdir,dataset,'_',num2str(val),'val_aspectratio.stl'];
outfile=[outdir,dataset,'_',num2str(val),'val_aspectratio.mp4'];

%% loading image stack
display('Loading smoothed image stack')
load(im_filenew);
IMAGEsm=IMAGEfilter;
load(par_file)
fv=stlread(stlfile);

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1200,1200]);
hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
% clear fv
isonormals(IMAGEsm,hiso)
alpha(0.2)  %sets level of transparency
view(3)
camlight
lighting gouraud
grid on
daspect([1 1 1]);
% newaspect=input('Want to try a new aspect ratio? No [enter], Yes [0] ');
% if exist(output.aspectratio)
newaspect=[1,1,1];
fvnew=fv;
while isempty(newaspect)==0
%     daspect(newaspect);
    final=newaspect/newaspect(1,1);
    % final=aspectratio;
    fvnew.vertices(:,1)=fv.vertices(:,1)/final(1);
    fvnew.vertices(:,2)=fv.vertices(:,2)/final(2);
    fvnew.vertices(:,3)=fv.vertices(:,3)/final(3);
    clf
    hiso=patch(fvnew,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
    isonormals(IMAGEsm,hiso)
    alpha(0.2)  %sets level of transparency
    view(3)
    camlight
    lighting gouraud
    grid on
    daspect([1 1 1]);
    if isempty(newaspect)==0
        aspectratio=newaspect;
    end
    newaspect=input('Want to try a new aspect ratio? No [enter], Yes [# # #] ');
    close all
end
output.aspectratio=aspectratio;
save(par_file,'output')
pause(1)

% final=aspectratio/aspectratio(1,1);
% % final=aspectratio;
% fv.vertices(:,1)=fv.vertices(:,1)/final(1);
% fv.vertices(:,2)=fv.vertices(:,2)/final(2);
% fv.vertices(:,3)=fv.vertices(:,3)/final(3);
% hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
stlwrite(outstl,fvnew);
save(outdata,'hiso');

%% saving rotating movie
display(['Saving 3DR movie with val = ',num2str(val)],'...');
% if exist(outfile,'file')==2
%     return
% else
h=figure(1);
set(h,'Position',[100,100,1000,1000]);
    hiso=patch(fvnew,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
    isonormals(IMAGEsm,hiso)
    alpha(0.2)  %sets level of transparency
    view(3)
    camlight
    lighting gouraud
    grid on
    daspect([1 1 1]);
    makevideo(outfile);
% end
clear IMAGEsm hiso
toc