function [imfinal,newmask] = bodyremovemanual(im,imnew,mask)
mask=logical(im);

figure(2)
imshowpair(im,imnew)
M = imfreehand(gca,'Closed',0);
F = false(size(M.createMask));
P0 = M.getPosition;
D = round([0; cumsum(sum(abs(diff(P0)),2))]); % Need the distance between points...
P = unique(round(P0),'rows');
S = sub2ind(size(im),P(:,2),P(:,1));
F(S) = true;
remove=imcomplement(imdilate(F,strel('disk',5)));
newmask=uint8(mask)-uint8(imcomplement(remove));

% if max(max(mask))==0
% else
%     newmask=uint8(remove)
% end
imfinal=uint8(imnew).*newmask;
figure(3)
imshowpair(im,imfinal)
% figure(4)
% imshowpair(mask,newmask)