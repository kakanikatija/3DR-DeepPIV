clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
percent=0.05; %percent allowable change in imwarp transform
inc=1;

%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel);
nFrames=finish-start;

display('Loading video data')
viddir=[dir,'clips/'];
vid=VideoReader([viddir,dataset,'.mov']);

%% arranging planar cross sections into "volume" matrix
display('Compiling image stack')
im_file=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGE.mat'];
if exist(im_file,'file')==2
    display('     Loading image stack...')
    load(im_file);                 %if exists, load original image stack
else
    display('     Computing image stack...')
    im=read(vid,1)*0;
    IMAGE(:,:,(finish-start)/inc)=im(:,:,1)*0;
    for i=start:inc:finish
        im=read(vid,i);
        if red==1
            IMAGE(:,:,(i-start)/inc+1)=im(:,:,1);
        else
            imgray=rgb2gray(im);
            IMAGE(:,:,(i-start)/inc+1)=imgray;
        end
    end
	display('     Saving image stack...')
    save(im_file,'IMAGE','-v7.3');        %save post-processing parameters
end
close all; clear vid

%% retrieving/determining data set-specific post-processing parameters
display('Defining post-processing parameters')
par_file=[dir,'output/',dataset,'_',num2str(vel),'vel_params.mat'];
if exist(par_file,'file')==2
    display('     Loading post-processing parameters...');
    load(par_file);                 %if exists, load post-proc parameters
else
    display('     Determining post-processing parameters...');
    hfig=crop_new(IMAGE);               %define cropped boundaries on image
    waitfor(hfig);
    hfig=manipulate_new(IMAGE,output);  %define threshold and filter settings
    waitfor(hfig);
    save(par_file,'output');        %save post-processing parameters
end
close all

%% cropping all images in stack
display('Cropping the image stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEcrop.mat'];
if exist(im_filenew,'file')==2
    display('     Loading cropped image stack...');
    load(im_filenew);
else
    display('     Creating cropped image stack...');
    IMAGEcrop=postprocIM(IMAGE,output);  %crop, threshold, and filter images
    save(im_filenew,'IMAGEcrop','-v7.3');        %save post-processing parameters
end
close all; clear IMAGE

%% unwarping all images in stack
display('Unwarping all images in stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEunwarp.mat'];
if exist(im_filenew,'file')==2
    display('     Loading unwarped image stack...');
    load(im_filenew);
else
    display('     Unwarping images in stack...');
    [optimizer, metric]  = imregconfig('monomodal');
    im1=IMAGEcrop(:,:,1);
    IMAGEunwarp=IMAGEcrop;
    for i=1:1:size(IMAGEcrop,3)-1
%         im1=IMAGEcrop(:,:,i);
        im2=IMAGEcrop(:,:,i+1);
        tform=imregtform(im2,im1,'rigid',optimizer,metric);
        rot=asin(tform.T(1,1));%xdisp=tform.T(3,1);ydisp=tform.T(3,2);
        if i>1
            rot2=asin(tform2.T(1,1));%xdisp2=tform2.T(3,1);ydisp2=tform2.T(3,2);
            if abs(rot-rot2)/abs(rot2)>percent %|| abs(xdisp-xdisp2)/max(abs([xdisp,xdisp2]))>percent || abs(ydisp-ydisp2)/max(abs([ydisp,ydisp2]))>percent
                tform=tform2;
            end
        end
        newim2 = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
        IMAGEunwarp(:,:,i+1)=newim2;
        figure(1)
        imshowpair(im1, newim2,'Scaling','joint');
%         imshow([IMAGEcrop(:,:,i),newim2])
        pause(0.1)
        im1=newim2;
        tform2=tform;
    end
    save(im_filenew,'IMAGEunwarp','-v7.3');
end
clear IMAGEcrop im1 im2 newim2 tform optimizer metric im_filenew

%% pos-processing all images in stack
display('Post-processed image stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEsm.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    display('     Computing post-processed image stack...');
    im=IMAGEunwarp(:,:,1)*0;imtop=im;imdil=im;imadj=im;imbin=im;imero=im;imnew=im;
    IMAGEnew=IMAGEunwarp*0;
    for i=1:1:size(IMAGEunwarp,3)
        im=IMAGEunwarp(:,:,i);
%         do imcontrast
        imnew=imoperations(im,dataset,contrast);
        IMAGEnew(:,:,i)=imnew;
    end
    IMAGEsm=smooth3(IMAGEnew);          %smooth images
    save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
end
close all; clear IMAGEnew

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