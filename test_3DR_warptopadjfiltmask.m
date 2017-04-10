clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_xlarge';
display(dataset);

val=10;
vel=10; %mm/s %UNKNOWN
inc=1;
%retrieving data set-specific parameters
[dir,start,finish,fps,fstop,shutter,calib,red,aspectratio]=videoinfo(dataset,vel);
nFrames=finish-start;

display('Loading video data')
viddir=[dir,'clips/'];
vid=VideoReader([viddir,dataset,'.mov']);

%% arranging planar cross sections into "volume" matrix
display('Compiling image stack')
% if red==1
% 	display('Arranging images into a stack using the red color channel only');
% else
%     display('Arranging images into a stack using grayscale of images');
% end
im_file=[viddir,'output/',dataset,'_IMAGE.mat'];
if exist(im_file,'file')==2
    display('     Loading image stack...')
    load(im_file);                 %if exists, load original image stack
else
    display('     Computing image stack...')
    im=read(vid,1)*0;
    IMAGE(:,:,(finish-start)/inc)=im;
    for i=start:inc:finish
        im=read(vid,i);
        if red==1
            IMAGE(:,:,(i-start)/inc+1)=im(:,:,1);
        else
%             imgray=rgb2gray(im);
            imgray=rgb2lab(im);
            IMAGE(:,:,(i-start)/inc+1)=imgray;
        end
    end
	display('     Saving image stack...')
    save(im_file,'IMAGE','-v7.3');        %save post-processing parameters
end
close all; clear vid im

%% retrieving/determining data set-specific post-processing parameters
display('Defining post-processing parameters')
par_file=[viddir,'output/',dataset,'_',num2str(vel),'vel_params.mat'];
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
im_filenew=[viddir,'output/',dataset,'_IMAGEcrop.mat'];
if exist(im_filenew,'file')==2
    display('     Loading cropped image stack...');
    load(im_filenew);
else
    display('     Creating cropped image stack...');
    IMAGEcrop=postprocIM(IMAGE,output);  %crop, threshold, and filter images
    save(im_filenew,'IMAGEcrop','-v7.3');        %save post-processing parameters
end
close all; clear IMAGE

%% applying image processing algorithms to stack
display('Applying dataset-specific image operations')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEnew.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    display('     Computing post-processed image stack...');
    IMAGEnew=IMAGEcrop*0;
    for i=1:1:size(IMAGEcrop,3)
        im=IMAGEcrop(:,:,i);
%         do imcontrast
        imnew=imoperations(im,dataset,contrast);
        IMAGEnew(:,:,i)=imnew;
    end
    save(im_filenew,'IMAGEnew','-v7.3');        %save post-processing parameters
end
close all; clear IMAGEcrop imnew im

% %% unwarping all images in stack
% display('Unwarping all images in stack')
% im_filenew=[viddir,'output/',dataset,'_IMAGEunwarp.mat'];
% if exist(im_filenew,'file')==1
%     display('     Loading unwarped image stack...');
%     load(im_filenew);
% else
%     display('     Unwarping images in stack...');
%     [optimizer, metric]  = imregconfig('monomodal');
%     im1=IMAGEcrop(:,:,1);
%     IMAGEunwarp=IMAGEcrop;
%     for i=1:1:size(IMAGEcrop,3)-1
% %         im1=IMAGEcrop(:,:,i);
%         im2=IMAGEcrop(:,:,i+1);
%         tform=imregtform(im2,im1,'rigid',optimizer,metric);
% %         if tform is much bigger than tform2
% %             tform=tform2;
% %         end
%         newim2 = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
%         IMAGEunwarp(:,:,i+1)=newim2;
%         figure(1)
% %         imshowpair(im1, newim2,'Scaling','joint');
%         imshow([IMAGEcrop(:,:,i),newim2])
%         pause(0.1)
%         im1=newim2;
%         tform2=tform;
%     end
%     save(im_filenew,'IMAGEunwarp','-v7.3');
% end
% clear IMAGEcrop im1 im2 newim2 tform optimizer metric im_filenew

%% pos-processing all images in stack
display('Post-processed image stack')
im_filenew=[viddir,'output/',dataset,'_IMAGEsmtopadjfiltmask.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    display('     Computing post-processed image stack...');
    im=IMAGEcrop(:,:,1)*0;imtop=im;imdil=im;imadj=im;imbin=im;imero=im;imnew=im;
    IMAGEnew=IMAGEcrop*0;
    for i=1:1:size(IMAGEcrop,3)
        im=IMAGEcrop(:,:,i);
        imtop = imtophat(im,strel('disk',15));
        imadj=imadjust(imtop,[0.08,0.39],[]);%using low and high limits provides absolute values for image adjustments
        imdil=imdilate(imadj,strel('disk',10));
        imbin=im2bw(imdil,0.3);
        imfilt=medfilt2(imadj,[5,5]);
        imfilled=imfill(imbin,'holes');
        imopen=bwareaopen(imfilled,1500,4);
        imnew=imfilt.*uint8(imopen);

        figure(1)
        imshow([im,imtop;imadj,imfilt])
        width=size(im,2);height=size(im,1);
        text(width*0.5,20,'im','Color','w','FontSize',16);text(width*1.5,20,'imtop','Color','w','FontSize',16);
        text(width*0.5,height,'imadj','Color','w','FontSize',16);text(width*1.5,height,'imfilt','Color','w','FontSize',16);        
        
%         figure(2)
%         imshow([im;imdil;imbin*255])
%         imdil=imdilate(imbin,strel('rectangle',[2,4]));
        figure(2)
        imshow([imbin*255,imdil*255;imfilled*255,imopen*255])
       	text(width*0.5,20,'imbin','Color','w','FontSize',16);text(width*1.5,20,'imdil','Color','w','FontSize',16);
        text(width*0.5,height,'imfilled','Color','w','FontSize',16);text(width*1.5,height,'imopen','Color','w','FontSize',16);
        figure(3)
        imshow([im,imnew])
       	text(width*0.5,20,'im','Color','w','FontSize',16);text(width*1.5,20,'imnew','Color','w','FontSize',16);
        IMAGEnew(:,:,i)=imnew;
    end
    IMAGEsm=smooth3(IMAGEnew);          %smooth images
    save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
end
close all; clear('IMAGEcrop','IMAGEnew')

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1000,1000]);
outdata=[viddir,'output/',dataset,'_hiso_',num2str(val),'.mat'];
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
    outstl=[viddir,'output/',dataset,'_output/',dataset,'_',num2str(val),'.stl'];
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
outfile=[viddir,'output/',dataset,'_output/',dataset,'_warptopadjfiltmask_',num2str(val),'.mp4'];
if exist(outfile,'file')==2
    return
else
    makevideo(outfile);
end
toc