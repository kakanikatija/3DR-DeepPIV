function [imfinal,mask] = filterfillmanual(im,imfinal,mask,maskbody)

figure(2)
% im=imadjust(im,[0.05,0.5],[0,1]);%.*uint8(mask);
% imshow(imnew.*uint8(imcomplement(mask)));
% mask=max(uint8(im2bw(im,0.2)),uint8(mask));
imshowpair(im,imfinal)
M = imfreehand(gca,'Closed',0);
% position=wait(M);
F = false(size(M.createMask));
P0 = M.getPosition;
% P0=unique(round(P0),'rows');
D = round([0; cumsum(sum(abs(diff(P0)),2))]); % Need the distance between points...
% P = interp1(D,P0,D(1):.5:D(end)); % ...to close the gaps
% P = interparc(0.5,P0(:,1),P0(:,2),'spline');
P = unique(round(P0),'rows');
S = sub2ind(size(im),P(:,2),P(:,1));
F(S) = true;
newmask=max(imdilate(F,strel('disk',5)),logical(mask)).*imcomplement(logical(maskbody));
imfinal=im.*uint8(newmask);
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
imshowpair(newmask,maskbody)
% imshow([im,imnew,immask,imadj,imfilt+imnew])
mask=logical(newmask);