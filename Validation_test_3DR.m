clc; clear; close all; warning('off');tic

dataset='60p_f13_250sh';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
% [dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo_MBP(dataset,vel);
nFrames=finish-start;

%% loading cropped image stack
display('Loading the cropped image stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEcrop.mat'];
load(im_filenew);

%% post-processing all images in stack
display('Post-processed image stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEsm.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    display('     Computing post-processed image stack...');
    IMAGEunwarp=IMAGEcrop;  %CHANGE THIS IF NOT USING VALIDATION IMAGES
    im=IMAGEunwarp(:,:,1)*0;imtop=im;imdil=im;imadj=im;imbin=im;imero=im;imnew=im;
    IMAGEnew=IMAGEunwarp*0;
    for i=1:1:size(IMAGEunwarp,3)
        im=IMAGEunwarp(:,:,i);
%         do imcontrast
        imnew=imoperations(im,dataset,contrast);
        IMAGEnew(:,:,i)=imnew;
    end
end
close all;

%%
display('Applying dataset-specific image operations')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEfinal.mat'];
if exist(im_filenew,'file')==2
    display('     Loading IMAGEfinal...');
    load(im_filenew);
else
    display('     Determining IMAGEfinal using manual removing...');
    IMAGEfinal=IMAGEnew*0;
    for i=1:1:size(IMAGEnew,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEunwarp(:,:,i);
        imfinal=IMAGEnew(:,:,i);
        imshowpair(im,imfinal)
        n=input('Next image: Do you need to manually remove? no = [enter], yes = 0 ');
        while n==0
            imfinal=imremovemanual(im,imfinal);
            n=input('Do you need to manually remove? no = [enter], yes = 0 ');
        end
        clear n
        imbin=im2bw(imfinal,0.1);
        immask=bwareaopen(imbin,1500,8);
        imfinal=medfilt2(imfinal.*uint8(immask),[5,5]);
        IMAGEfinal(:,:,i)=imfinal;
        imshow(imfinal)
    end
	save(im_filenew,'IMAGEfinal','-v7.3');        %save post-processing parameters
end
close all; clear IMAGEnew IMAGEunwarp

display('Post-processed image stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEsm.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    IMAGEsm=smooth3(IMAGEfinal);          %smooth images
    save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
end
close all; clear IMAGEfinal

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1000,1000]);
outdata=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val_hiso.mat'];
if exist(outdata,'file')==2
    display(['     Loading isosurface data with val = ',num2str(val),'...']);
    load(outdata);
else
    display(['     Calculating isosurface data with val = ',num2str(val),'...']);
    [X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
    newaspect=aspectratio/aspectratio(1,1);
    xx=single(X)/newaspect(1);yy=single(Y)/newaspect(2);zz=single(Z)/newaspect(3);
    clear X Y Z
    fv=isosurface(xx,yy,zz,IMAGEsm,val,'verbose');
    display(['     Saving isosurface data with val = ',num2str(val),'...']);
    outstl=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val.stl'];
    stlwrite(outstl,fv);
    hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
    clear fv xx yy zz
    save(outdata,'hiso');
end
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
outfile=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val_warpadjfiltmask.mp4'];
if exist(outfile,'file')==2
    return
else
    makevideo(outfile);
end
toc