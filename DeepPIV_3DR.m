function DeepPIV_3DR(dataset)

global vel 
tic
display(dataset);

% val=10;
% vel=10; %mm/s %UNKNOWN
% percent=0.05;
inc=1;
%% retrieving data set-specific parameters
[dir,start,finish,~,~,~,~,~,~,~]=videoinfo(dataset,vel);
% [dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo_MBP(dataset,vel);

display('Loading video')
viddir=[dir,'clips/'];
% outdir=[dir,'output/'];
indir=[dir,'input/'];

%% arranging planar cross sections into "volume" matrix
% im_file=[indir,dataset,num2str(vel),'vel_IMAGE.mat'];
% im_filenew=[indir,dataset,num2str(vel),'vel_IMAGEcrop.mat'];
im_file=[indir,dataset,'_IMAGE.mat'];
im_filenew=[indir,dataset,'_IMAGEcrop.mat'];
if exist(im_file,'file')==2 && exist(im_filenew,'file')==0
    load(im_file);                 %if exists, load original image stack
    display(['Image stack for ', dataset,' already exists.'])
elseif exist(im_file,'file')==2 && exist(im_filenew,'file')==2
    display(['Image stack and cropping for ', dataset,' already exists.'])
    return
else
    vid=VideoReader([viddir,dataset,'.mov']);
    im=read(vid,1);
    IMAGE(:,:,(finish-start)/inc)=im(:,:,1).*0;
    clear im
    for i=start:inc:finish
        im=read(vid,i);
        imgray=rgb2gray(im);
%         imgray=rgb2lab(im);
    	IMAGE(:,:,(i-start)/inc+1)=imgray;
    end
    save(im_file,'IMAGE','-v7.3');        %save post-processing parameters
    close all; clear vid im imgray
    %% cropping all images in stack
    display('Cropping the image stack')
    % retrieving/determining data set-specific post-processing parameters
    display('Defining post-processing parameters')
    par_file=[indir,dataset,'_',num2str(vel),'vel_params.mat'];
    if exist(par_file,'file')==2
        load(par_file);                 %if exists, load post-proc parameters
    else
        hfig=crop_new(IMAGE);               %define cropped boundaries on image
        waitfor(hfig);
        hfig=manipulate_new(IMAGE,output);  %define threshold and filter settings
        waitfor(hfig);
        save(par_file,'output');        %save post-processing parameters
    end
    IMAGEcrop=postprocIM(IMAGE,output);  %crop, threshold, and filter images
    save(im_filenew,'IMAGEcrop','-v7.3');        %save post-processing parameters
    close all; clear IMAGE
end


% %% unwarping all images in stack
% display('Unwarping all images in stack')
% im_filenew=[outdir,dataset,'_',num2str(vel),'vel_IMAGEunwarp.mat'];
% if exist(im_filenew,'file')==2
%     load(im_filenew);
% else
%     [optimizer, metric]  = imregconfig('monomodal');
%     im1=IMAGEcrop(:,:,1);
%     IMAGEunwarp=IMAGEcrop;
%     for i=1:1:size(IMAGEcrop,3)-1
%         im2=IMAGEcrop(:,:,i+1);
%         tform=imregtform(im2,im1,'rigid',optimizer,metric);
%         rot=asin(tform.T(1,1));%xdisp=tform.T(3,1);ydisp=tform.T(3,2);
%         if i>1
%             rot2=asin(tform2.T(1,1));%xdisp2=tform2.T(3,1);ydisp2=tform2.T(3,2);
%             if abs(rot-rot2)/abs(rot2)>percent %|| abs(xdisp-xdisp2)/max(abs([xdisp,xdisp2]))>percent || abs(ydisp-ydisp2)/max(abs([ydisp,ydisp2]))>percent
%                 tform=tform2;
%             end
%         end
%         newim2 = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
%         IMAGEunwarp(:,:,i+1)=newim2;
%         im1=newim2;
%         tform2=tform;
%     end
%     save(im_filenew,'IMAGEunwarp','-v7.3');
% end
% clear im1 im2 newim2 tform optimizer metric im_filenew IMAGEcrop

% %% post-process all cross section images
% display('Smoothing between planes of image stack')
% im_filenew=[outdir,dataset,'_IMAGEsm.mat'];
% if exist(im_filenew,'file')==2
%     load(im_filenew);
% else
%     IMAGEsm=smooth3(IMAGEcrop);          %smooth images
%     save(im_filenew,'IMAGEsm','-v7.3');        %save post-processing parameters
% end
% close all; clear IMAGEcrop

% %% plotting 3D reconstruction
% display('Plotting 3D reconstruction');
% h=figure(3);
% set(h,'Position',[100,100,1000,1000]);
% outdata=[outdir,dataset,'_hiso_',num2str(val),'.mat'];
% if exist(outdata,'file')==2
%     load(outdata);
% else
%     [X,Y,Z]=meshgrid(1:size(IMAGEsm,2),1:size(IMAGEsm,1),1:size(IMAGEsm,3));
%     newaspect=aspectratio/aspectratio(1,1);
%     xx=single(X)/newaspect(1);yy=single(Y)/newaspect(2);zz=single(Z)/newaspect(3);
%     clear X Y Z
%     fv=isosurface(xx,yy,zz,IMAGEsm,val,'verbose');
%     clear xx yy zz
%     outstl=[outdir,dataset,'_',num2str(val),'.stl'];
%     stlwrite(outstl,fv);
%     hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
%     save(outdata,'hiso');
%     clear fv
% end
% isonormals(IMAGEsm,hiso)
% alpha(0.2)  %sets level of transparency
% view(3)
% camlight
% lighting gouraud
% grid on
% daspect([1 1 1]);
% 
% %% saving rotating movie
% display(['Saving 3DR movie with val = ',num2str(val)],'...');
% outfile=[outdir,dataset,'_unwarp-raw_',num2str(val),'.mp4'];
% if exist(outfile,'file')==2
%     return
% else
%     makevideo(outfile);
% end
% clear IMAGEsm hiso
% toc