function [imfinal,mask] = removeblobs(im,imfinal,mask)

figure(2)
imnew=imadjust(im,[0,0.5],[0,1]);
imshow(logical(mask));
newmask=bwselect(logical(mask),4);
imshow(newmask);
newmask=uint8(newmask);
imfinal=imnew.*newmask;
mask=newmask;