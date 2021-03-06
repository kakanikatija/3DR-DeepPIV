function imfinal = imremovemanual(im,imnew)

figure(2)
imadj=imadjust(im,[0,0.2],[0,1]);
% mask=uint8(imcomplement(im2bw(imnew,0.1)));
imshow(imadj);
% imshowpair(im,imnew)
% imshowpair(imnew,imadj)
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
mask=imdilate(F,strel('disk',5));
imfinal=imnew.*uint8(imcomplement(mask));
% imadj=imadjust(immask,[10 50]/255,[0 1]);
% imfilt=medfilt2(imadj,[5,5]);
% imbin=im2bw(imadj,0.15);
% imopen=bwareaopen(imbin,10,4);
% imdil=imdilate(imopen,strel('disk',1));
% imfinal=imfilt+imnew;
figure(1)
imshowpair(im,imfinal)
% imshow([im,imnew,immask,imadj,imfilt+imnew])
