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

%% post-processing all images in stack
display('Unwarping all images in stack')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEunwarp.mat'];
if exist(im_filenew,'file')==2
    display('     Loading unwarped image stack...');
    load(im_filenew);
else
    display('     Images are still warped.');
    break
end
    
display('Applying dataset-specific image operations')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEnew.mat'];
if exist(im_filenew,'file')==2
    display('     Loading post-processed image stack...');
    load(im_filenew);
else
    display('     Computing post-processed image stack...');
    IMAGEnew=IMAGEunwarp*0;
    for i=1:1:size(IMAGEunwarp,3)
        im=IMAGEunwarp(:,:,i);
%         do imcontrast
        imnew=imoperations(im,dataset,contrast);
        IMAGEnew(:,:,i)=imnew;
    end
    save(im_filenew,'IMAGEnew','-v7.3');        %save post-processing parameters
end
close all;

%%
display('Applying dataset-specific image operations')
im_filenew=[dir,'output/',dataset,'_',num2str(vel),'vel_IMAGEfinal.mat'];
if exist(im_filenew,'file')==2
    display('     Loading IMAGEfinal...');
    load(im_filenew);
else
    display('     Determining IMAGEfinal using manual filling...');
    IMAGEfinal=IMAGEnew*0;
    for i=1:158:size(IMAGEnew,3)
        display(['frame number: ',num2str(i)]);
        im=IMAGEunwarp(:,:,i);
        imfinal=IMAGEnew(:,:,i);
        imshowpair(im,imfinal)
        n=input('Next image: Do you need to manually fill? no = [enter], yes = 0 ');
        while n==0
            imfinal=imfillmanual(im,imfinal);
            n=input('Do you need to manually fill? no = [enter], yes = 0 ');
        end
        clear n
        IMAGEfinal(:,:,i)=imfinal;
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
outfile=[dir,'output/',dataset,'_',num2str(vel),'vel_',num2str(val),'val_final.mp4'];
if exist(outfile,'file')==2
    return
else
    makevideo(outfile);
end
toc