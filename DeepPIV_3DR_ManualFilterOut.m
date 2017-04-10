clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_small';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
viddir=[dir,'clips/'];
indir=[dir,'input/'];
outdir=[dir,'output/'];
nFrames=finish-start;

preim_file=[indir,dataset,'_IMAGEprebody'];
im_file=[indir,dataset,'_IMAGEbody.mat'];
mask_file=[indir,dataset,'_MASKbody.mat'];
imfilt_file=[indir,dataset,'_IMAGEfilter.mat'];
maskfilt_file=[indir,dataset,'_MASKfilter.mat'];
if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(preim_file);
    load(im_file);
    load(mask_file);
    load(imfilt_file);
    load(maskfilt_file);
else
    display('     Body points are not extracted. Run DeepPIV_3DR_ManualBody.m.')
    break
end

%% extract filter features manually
display('Extracting filter features manually')
    IMAGEout=IMAGEfilter.*0;
    MASKout=MASKfilter;
    
    for i=242:1:size(IMAGEprebody,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEprebody(:,:,i);
        imbody=IMAGEbody(:,:,i);
        maskbody=MASK(:,:,i);
        imfilt=IMAGEfilter(:,:,i);
        maskfilt=MASKfilter(:,:,i);
        mask=maskfilt.*0;imfinal=im.*0;
        imnew=imadjust(im,[0,0.3],[0,1]);
        imtot=max(imbody,imfilt);
        masktot=max(uint8(maskfilt),uint8(maskbody));
        figure(1)
        imshowpair(imnew,imtot);
        n=input('Next image: Do you need to manually extract? no = [enter], yes = 0 ');
%         n=0;
        while n==0
            [imfinal,mask]=filterfillmanual(imnew,imfinal,mask,masktot);
            m=input('Do you need to fill mask? no [enter], yes [0] ');
            if m==0
                mask=imfill(mask);
                imfinal=imnew.*uint8(mask);
                imshow(imfinal)
            end
            n=input('Do you need to manually extract? no = [enter], yes = 0 ');
        end
        clear n
        IMAGEout(:,:,i)=imfinal;
        MASKout(:,:,i)=mask;
    end
    im_filenew=[indir,dataset,'_IMAGEfilterout.mat'];
    save(im_filenew,'IMAGEout','-v7.3');        %save post-processing parameters
%     im_filenew=[indir,dataset,'_',num2str(vel),'vel_MASKbody.mat'];
    im_filenew=[indir,dataset,'_MASKfilterout.mat'];
	save(im_filenew,'MASKout','-v7.3');        %save post-processing parameters
% end
close all; clear IMAGEprebody MASK


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