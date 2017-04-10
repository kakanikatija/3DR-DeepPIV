clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);

n=2;    %n=1 is body; n=2 is inner filter; n=3 is outer filter
val=2;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
nFrames=finish-start;

%% extract body features manually
display('Extracting body features manually')
% im_file=[indir,dataset,'_',num2str(vel),'vel_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_',num2str(vel),'vel_MASKbody.mat'];
% outdata=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_hiso_body.mat'];
% outstl=[outdir,dataset,'_',num2str(val),'val_',num2str(vel),'vel_body.stl'];
if n==1
    im_file=[indir,dataset,'_IMAGEbody.mat'];
    mask_file=[indir,dataset,'_MASKbody.mat'];
    outdata=[outdir,dataset,'_',num2str(val),'val_hiso_body.mat'];
    outstl=[outdir,dataset,'_',num2str(val),'val_body.stl'];
    outmov=[outdir,dataset,'_',num2str(val),'val_body.mp4'];
    outsm=[indir,dataset,'_',num2str(vel),'vel_IMAGEsm.mat'];
elseif n==2
%     im_file=[indir,dataset,'_IMAGEfilter.mat'];
%     mask_file=[indir,dataset,'_MASKfilter.mat'];
%     outdata=[outdir,dataset,'_',num2str(val),'val_hiso_filt.mat'];
%     outstl=[outdir,dataset,'_',num2str(val),'val_filt.stl'];
%     outmov=[outdir,dataset,'_',num2str(val),'val_filt.mp4'];
%     outsm=[indir,dataset,'_',num2str(vel),'vel_IMAGEfiltsm.mat'];
    im_file=[indir,dataset,'_IMAGEfilternew.mat'];
    mask_file=[indir,dataset,'_MASKfilternew.mat'];
    outdata=[outdir,dataset,'_',num2str(val),'val_hiso_filtnew.mat'];
    outstl=[outdir,dataset,'_',num2str(val),'val_filtnew.stl'];
    outmov=[outdir,dataset,'_',num2str(val),'val_filtnew.mp4'];
    outsm=[indir,dataset,'_',num2str(vel),'vel_IMAGEfiltsmnew.mat'];
elseif n==3
    im_file=[indir,dataset,'_IMAGEfilterout.mat'];
    mask_file=[indir,dataset,'_MASKfilterout.mat'];
    outdata=[outdir,dataset,'_',num2str(val),'val_hiso_filtout.mat'];
    outstl=[outdir,dataset,'_',num2str(val),'val_filtout.stl'];
    outmov=[outdir,dataset,'_',num2str(val),'val_filtout.mp4'];
    outsm=[indir,dataset,'_',num2str(vel),'vel_IMAGEoutsm.mat'];
end
if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(im_file);
%     load(mask_file);
else
    display('     Body points are not extracted. Run DeepPIV_3DR_ManualBody.m.')
    break
end

%% Smoothing adjacent images in stack
display('Smoothing images in body image stack')
if n==3
    IMAGEsm=smooth3(IMAGEout);          %smooth images
elseif n==2
    IMAGEsm=smooth3(IMAGEfilternew);          %smooth images
%     IMAGEsm=smooth3(IMAGEfilter);          %smooth images
elseif n==1
    IMAGEsm=smooth3(IMAGEbody);          %smooth images
end
save(outsm,'IMAGEsm','-v7.3');        %save post-processing parameters
close all; clear IMAGEbody

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1200,1200]);
display(['     Calculating isosurface data with val = ',num2str(val),'...']);
[X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
newaspect=aspectratio/aspectratio(1,1);
xx=single(X)/newaspect(1);yy=single(Y)/newaspect(2);zz=single(Z)/newaspect(3);
clear X Y Z
fv=isosurface(xx,yy,zz,IMAGEsm,val,'verbose');
clear xx yy zz
display(['     Saving isosurface data with val = ',num2str(val),'...']);
stlwrite(outstl,fv);
hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
save(outdata,'hiso');

display(['     Plotting isosurface data with val = ',num2str(val),'...']);
isonormals(IMAGEsm,hiso)
alpha(0.2)  %sets level of transparency
view(3)
camlight
lighting gouraud
grid on
daspect([1 1 1]);
% axis equal

%%
display(['     Saving 3DR movie with val = ',num2str(val)],'...');
makevideo(outmov);
toc