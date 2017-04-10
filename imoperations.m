function [imnew,mask] = imoperations(im,dataset,contrast)
imnew=im*0;
mask=0;
if strcmp(dataset,'60p_f13_250sh')==1
%         imtop = imtophat(im,strel('disk',15));
        imadj=imadjust(im,contrast,[]);%using low and high limits provides absolute values for image adjustments
        imer=imerode(imadj,strel('disk',10));
        imfilt=medfilt2(imer,[5,5]);
%         imbrad=bradley(imfilt,[10,10],100,'replicate');
%         text(width*0.5,20,'im','Color','w','FontSize',16);text(width*1.5,20,'imtop','Color','w','FontSize',16);
%         text(width*0.5,height,'imadj','Color','w','FontSize',16);text(width*1.5,height,'imfilt','Color','w','FontSize',16);        
        imbin=im2bw(imfilt,0.3);
%         figure(2)
%         imshow([im,imdil,imbin*255])
%         imfilled=imfill(imbin,'holes');
%         imopen=bwareaopen(imfilled,50,8);
%         imer=imerode(imopen,strel('disk',10));
%         figure(2)
%         imshow([imbin*255,imdil*255;imfilled*255,imopen*255])
%        	text(width*0.5,20,'imbin','Color','w','FontSize',16);text(width*1.5,20,'imdil','Color','w','FontSize',16);
%         text(width*0.5,height,'imfilled','Color','w','FontSize',16);text(width*1.5,height,'imopen','Color','w','FontSize',16);
        imnew=im.*uint8(imbin);
elseif strcmp(dataset,'00037_converted(1)')==1
%   	imtop = imtophat(im,strel('disk',15));
  	imadj=imadjust(im,contrast,[]);%using low and high limits provides absolute values for image adjustments
 	imfilt=medfilt2(imadj,[10,10]);
  	imbin=im2bw(imfilt,0.15);
 	imfilled=imfill(imbin,'holes');
  	imopen=bwareaopen(imfilled,50,8);
   	imer=imerode(imopen,strel('disk',10));
 	imnew=imer;
elseif strcmp(dataset,'150522_SC1ATK22_3DR_10')==1
    imadj=imadjust(im,contrast,[]);
    imdil=imdilate(imadj,strel('disk',1));
    imfilt=medfilt2(imdil,[10,10]);
    imbin=im2bw(imfilt,0.35);
    imfilled=imfill(imbin,'holes');
    imnew=uint8(imfilled)*255;%im.*uint8(imfilled);
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_xlarge')==1
	imtop = imtophat(im,strel('disk',15));
	imadj=imadjust(imtop,contrast,[0,1]);%[0.08,0.39],[]);%using low and high limits provides absolute values for image adjustments
	imdil=imdilate(imadj,strel('disk',2));
 	imbin=im2bw(imdil,0.1);
 	imopen=bwareaopen(imbin,50,4);
%   	imfilt=medfilt2(imadj,[5,5]);
 	imnew=imadj.*uint8(imopen);
elseif strcmp(dataset,'151202_SC1ATK64_EggMass_2')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>65,'spur'),'close'),50);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_8')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>35,'spur'),'close'),70);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_9')==1    %OIL
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>180,'spur'),'close'),70);
    imnew=imadj.*uint8(mask);
% elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_9')==1 %ORIGINAL
%     imadj=imadjust(im,[0.01,0.5],[0,1]);
%     mask=bwareaopen(bwmorph(bwmorph(imadj>75,'spur'),'close'),70);
%     imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_10')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>70,'spur'),'close'),70);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151202_SC1ATK65_Ctenophore_7')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>40,'spur'),'close'),70);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151205_SC1ATK68_Batho_2')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>30,'spur'),'close'),60);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151205_SC1ATK67_Batho_4')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>80,'spur'),'close'),70);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_11')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>80,'spur'),'close'),60);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_14')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>80,'spur'),'close'),60);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_17')==1
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>80,'spur'),'close'),60);
    imnew=imadj.*uint8(mask);
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_med')==1    %%BODY
    imadj=imadjust(im,[0.01,0.5],[0,1]);
    mask=bwareaopen(bwmorph(bwmorph(imadj>20,'spur'),'close'),60);
    imnew=imadj.*uint8(mask);
% elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_med')==1    %%HOUSE
%     imadj=imadjust(im,[0.01,0.5],[0,1]);
% %     mask=imfill(bwareaopen(bwmorph(bwmorph(bwmorph(imadj>10,'spur'),'close'),'thicken'),150),'holes');
%     mask=imfill(bwareaopen(bwmorph(bwmorph(bwmorph(imadj>11,'bridge'),'close'),'thicken'),40),'holes');
% %     mask=bwareaopen(bwmorph(bwmorph(imadj>20,'spur'),'close'),60);
%     imnew=imadj.*uint8(mask);
end

% figure(1)
% imshow([im,imfilt,imbin*255,imfilled*255,imnew])
% pause(0.1)