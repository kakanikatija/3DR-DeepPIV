function [imfinal,newmask] = bodyremoveblobs(im,imfinal,mask,m1,m2)
figure(2)
imshowpair(im,imfinal);
if max(max(mask))>0 && isempty(m1)==0 && isempty(m2)==1
    tempmask=bwselect(logical(imfinal),4);
    newmask=uint8(tempmask);
elseif max(max(mask))==0
    tempmask=bwselect(logical(im),4);
    newmask=uint8(tempmask);
elseif max(max(mask))>0 && isempty(m2)==0
    tempmask=bwselect(logical(im-mask),4);
    newmask=uint8(tempmask)+mask;
end
imshow(newmask);
imfinal=im.*newmask;

figure(2)
imshowpair(im,imfinal)