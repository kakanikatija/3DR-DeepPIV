function [imfinal,mask] = filterremovemanual(imnew,imfinal,mask,maskbody)

figure(2)
% imnew=imadjust(im,[0,0.5],[0,1]);
% imshow(imnew.*uint8(imcomplement(mask)));
imshowpair(imnew,imfinal)
M = imfreehand(gca,'Closed',0);
% position=wait(M);
F = false(size(M.createMask));
P0 = M.getPosition;
% P0=unique(round(P0),'rows');
D = round([0; cumsum(sum(abs(diff(P0)),2))]); % Need the distance between points...
% P = interp1(D,P0,D(1):.5:D(end)); % ...to close the gaps
% P = interparc(0.5,P0(:,1),P0(:,2),'spline');
P = unique(round(P0),'rows');
S = sub2ind(size(imnew),P(:,2),P(:,1));
F(S) = true;
remove=imcomplement(imdilate(F,strel('disk',5)));
newmask=uint8(remove).*uint8(mask).*imcomplement(uint8(maskbody));
imfinal=imnew.*uint8(logical(newmask));
% imadj=imadjust(immask,[10 50]/255,[0 1]);
% imfilt=medfilt2(imadj,[5,5]);
% imbin=im2bw(imadj,0.15);
% imopen=bwareaopen(imbin,10,4);
% imdil=imdilate(imopen,strel('disk',1));
% imfinal=max(oldim,immask);
figure(3)
% imshowpair(im,imfinal)
imshow(imfinal)
figure(4)
imshowpair(newmask,mask)
% imshow([im,imnew,immask,imadj,imfilt+imnew])
mask=newmask;