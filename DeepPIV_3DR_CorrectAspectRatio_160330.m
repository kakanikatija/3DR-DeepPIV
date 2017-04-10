clc; clear; close all;
tic
dataset='151205_SC1ATK67_Batho_4';
mesh='Batho_4_10val_body_clean_6611sm';
folder='Batho_4/';
val=10;
vel=10;
inc=1;
%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
% dir=dir(13:end);
meshdir=[dir,'meshlab/',folder];
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
par_file=[indir,dataset,'_params.mat'];

im_filenew=[indir,dataset,'_IMAGEcrop.mat'];
% im_filenew=[indir,dataset,'_IMAGEfilter.mat'];
% stlfile=[outdir,dataset,'_',num2str(val),'val.stl'];
stlfile=[meshdir,mesh,'.stl'];
outdata=[outdir,mesh,'_hiso_aspectratio.mat'];
outstl=[outdir,mesh,'_aspectratio.stl'];
outfile=[outdir,mesh,'_aspectratio.mp4'];

%% loading image stack
display('Loading smoothed image stack')
load(im_filenew);
% IMAGEsm=IMAGEfilter;
load(par_file)
fv=stlread(stlfile);

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1200,1200]);
hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
% clear fv
isonormals(IMAGEcrop,hiso)
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
    isonormals(IMAGEcrop,hiso)
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

% %% saving rotating movie
% display(['Saving 3DR movie with val = ',num2str(val)],'...');
% % if exist(outfile,'file')==2
% %     return
% % else
% h=figure(1);
% set(h,'Position',[100,100,1000,1000]);
%     hiso=patch(fvnew,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
%     isonormals(IMAGEsm,hiso)
%     alpha(0.2)  %sets level of transparency
%     view(3)
%     camlight
%     lighting gouraud
%     grid on
%     daspect([1 1 1]);
%     makevideo(outfile);
% % end
% clear IMAGEsm hiso
% toc