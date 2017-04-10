clc; clear; close all; warning('off');tic

dataset='151202_SC1ATK64_Desmophyes_9';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
dir=dir(13:end);
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
nFrames=finish-start;

% preim_file=[indir,dataset,'_IMAGEprebody'];
% im_file=[indir,dataset,'_IMAGEbody.mat'];
% mask_file=[indir,dataset,'_MASKbody.mat'];
im_file=[indir,dataset,'_IMAGEcrop.mat'];
im_out=[indir,dataset,'_IMAGEoil.mat'];
mask_out=[indir,dataset,'_MASKoil.mat'];
if exist(im_file,'file')==2 && exist(im_out,'file')==2
    display('     Filtered image stack already exists.')
    return
elseif exist(im_file,'file')==2 && exist(im_out,'file')==0    
    display('     Loading IMAGE stacks...');
%    load(preim_file);
    load(im_file);
%    load(mask_file);
else
    display('     Cropped image stack does not exist. Run DeepPIV_3DR_batch.m.')
    break
end

%% extract filter features automatically
display('Extracting filter features automatically')
    IMAGEfilter=IMAGEcrop.*0;
    MASKfilter=IMAGEcrop.*0;
    
    for i=1:1:size(IMAGEcrop,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEcrop(:,:,i);
        [imnew,mask] = imoperations(im,dataset,contrast);
        figure(2)
        imshow([im,imnew]);
    	text(100,100,['frame #: ',num2str(i)],'Color','w','FontSize',18)
        pause(0.1)
        IMAGEfilter(:,:,i)=imnew;
        MASKfilter(:,:,i)=mask;
        clear index
    end
save(im_out,'IMAGEfilter','-v7.3');        %save post-processing parameters
save(mask_out,'MASKfilter','-v7.3');        %save post-processing parameters

% %% plotting 3D reconstruction
% display('Plotting 3D reconstruction');
% h=figure(3);
% set(h,'Position',[100,100,1000,1000]);
% outdata=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val_hiso.mat'];
% if exist(outdata,'file')==2
%     display(['     Loading isosurface data with val = ',num2str(val),'...']);
%     load(outdata);
% else
%     display(['     Calculating isosurface data with val = ',num2str(val),'...']);
%     [X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
%     newaspect=aspectratio/aspectratio(1,1);
%     xx=single(X)/newaspect(1);yy=single(Y)/newaspect(2);zz=single(Z)/newaspect(3);
%     clear X Y Z
%     fv=isosurface(xx,yy,zz,IMAGEsm,val,'verbose');
%     display(['     Saving isosurface data with val = ',num2str(val),'...']);
%     outstl=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val.stl'];
%     stlwrite(outstl,fv);
%     hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
%     clear fv xx yy zz
%     save(outdata,'hiso');
% end
% display(['     Plotting isosurface data with val = ',num2str(val),'...']);
% isonormals(IMAGEsm,hiso)
% alpha(0.2)  %sets level of transparency
% view(3)
% camlight
% lighting gouraud
% grid on
% daspect([1 1 1]);
% % axis equal
% 
% %%
% display(['     Saving 3DR movie with val = ',num2str(val)],'...');
% outfile=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val_final.mp4'];
% if exist(outfile,'file')==2
%     return
% else
%     makevideo(outfile);
% end
% toc