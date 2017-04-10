clc; clear; close all; warning('off');tic

dataset='150811_DeepPIV_BathoStyg_3DR_med';
display(dataset);

val=1;
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

%% extract body features manually
display('Loading images for smoothing.')
% im_file=[indir,dataset,'_IMAGEfilter.mat'];
% mask_file=[indir,dataset,'_MASKfilter.mat'];
% outdata=[outdir,dataset,'_',num2str(val),'val_hiso.mat'];
% outstl=[outdir,dataset,'_',num2str(val),'val.stl'];
% outfile=[outdir,dataset,'_',num2str(val),'val.mp4'];
im_file=[indir,dataset,'_IMAGEbodyCorr.mat'];
% mask_file=[indir,dataset,'_MASKbodyCorrected.mat'];
im_outfile=[indir,dataset,'_IMAGEbodyCorrsm.mat'];
outdata=[outdir,dataset,'_',num2str(val),'val_bodyhiso.mat'];
outstl=[outdir,dataset,'_',num2str(val),'valbody.stl'];
outfile=[outdir,dataset,'_',num2str(val),'valbody.mp4'];
% im_file=[indir,dataset,'_IMAGEhouseCorr.mat'];
% im_outfile=[indir,dataset,'_IMAGEhouseCorrsm.mat'];
% % mask_file=[indir,dataset,'_MASKhouseCorrected.mat'];
% outdata=[outdir,dataset,'_',num2str(val),'val_househiso.mat'];
% outstl=[outdir,dataset,'_',num2str(val),'valhouse.stl'];
% outfile=[outdir,dataset,'_',num2str(val),'valhouse.mp4'];

if exist(im_file,'file')==2
    display('     Loading IMAGE stacks...');
    load(im_file);
else
    display('     Cropped image stack does not exist. Run DeepPIV_3DR_Batch.m.')
    break
end
%%%%%%%%

IMAGEfilter=IMAGEbody;
% IMAGEfilter=IMAGEhouse;
IMAGEunwarp=IMAGEfilter;%%COMMENT OUT WHEN USING UNWARP
%%%%%%%%

% %% unwarping all images in stack
% display('Unwarping all images in stack')
% im_file=[indir,dataset,'_IMAGEunwarp.mat'];
% data_file=[indir,dataset,'_transform.mat'];
% if exist(im_file,'file')==2
%     load(im_file);
% elseif exist(data_file,'file')==2 && exist(im_file,'file')==0
%     load(data_file);
%     IMAGEunwarp=IMAGEfilter;
%     for i=1:1:size(IMAGEfilter,3)-1
%         tform=transform(:,:,i);
%         im=IMAGEfilter(:,:,i+1);%makethemstoptalkingplease
%         newim = imwarp(im,tform,'OutputView',imref2d(size(im)));
%         IMAGEunwarp(:,:,i+1)=newim;
%     end
%     save(im_file,'IMAGEunwarp','-v7.3');
% else
%     [optimizer, metric]  = imregconfig('monomodal');
%     im1=IMAGEfilter(:,:,1);%makethemstoptalkingplease
%     im2=IMAGEfilter(:,:,2);
% 	tform=imregtform(im2,im1,'rigid',optimizer,metric);
%     IMAGEunwarp=IMAGEfilter;
%     counter=0;
%     for i=1:1:size(IMAGEfilter,3)-1
%         display([num2str((size(IMAGEfilter,3)-i)/size(IMAGEfilter,3)*100),'% complete'])
%         if max(max(IMAGEfilter(:,:,i)))>0
%             counter=counter+1;
%             im2=IMAGEfilter(:,:,i+1);
%             tform=imregtform(im2,im1,'rigid',optimizer,metric);
%             rot=asin(tform.T(1,1));xdisp=tform.T(3,1);ydisp=tform.T(3,2);
%             if counter>1 
%                 rot2=asin(tform2.T(1,1));xdisp2=tform2.T(3,1);ydisp2=tform2.T(3,2);
%                 if abs(rot-rot2)/abs(rot2)>percent || abs(xdisp-xdisp2)/max(abs([xdisp,xdisp2]))>percent || abs(ydisp-ydisp2)/max(abs([ydisp,ydisp2]))>percent
%                     tform=tform2;
%                 end
%             end
%             newim2 = imwarp(im2,tform,'OutputView',imref2d(size(im1)));
%         else
%             newim2 = im1.*0;
%         end
%         IMAGEunwarp(:,:,i+1)=newim2;
%         im1=newim2;
%         transform(:,:,i)=tform;
%         tform2=tform;
% %         counter=0;
%     end
% end
% clear im1 im2 newim2 tform tform2 optimizer metric im_filenew IMAGEfilter
% 
% for i=1:1:size(IMAGEunwarp,3)
%     imshow(IMAGEunwarp(:,:,i))
%     pause(0.1)
% end
% 
% n=input('Are you satisfied with the unwarped image stack? Yes [enter]; No [0] ');
% if n==0
%     break
% else
%  	save(im_file,'IMAGEunwarp','-v7.3');
%     save(data_file,'transform');
% end

% Smoothing adjacent images in stack
display('Smoothing images in body image stack')
% if exist(im_outfile,'file')==2
%     display('     Loading post-processed image stack...');
%     load(im_outfile);
% else
    IMAGEsm=smooth3(IMAGEunwarp);          %smooth images
    save(im_outfile,'IMAGEsm','-v7.3');        %save post-processing parameters
% end
close all; clear IMAGEunwarp

%% plotting 3D reconstruction
display('Plotting 3D reconstruction');
h=figure(3);
set(h,'Position',[100,100,1000,1000]);
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
    clear xx yy zz
    display(['     Saving isosurface data with val = ',num2str(val),'...']);
    stlwrite(outstl,fv);
    hiso=patch(fv,'FaceColor',[0.5,0.5,0.65],'EdgeColor','none');
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
% display(['     Saving 3DR movie with val = ',num2str(val)],'...');
% if exist(outfile,'file')==2
%     return
% else
%     makevideo(outfile);
% end
toc