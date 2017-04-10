function [imfinal,mask] = removeblobsdraw(im,imfinal,mask)
newmask=0*mask;
figure(2)
imshowpair(mask,uint8(newmask));
imnew=imadjust(im,[0,0.5],[0,1]);
newmask=bwselect(logical(mask),4);
figure(2)
imshowpair(mask,uint8(newmask));
q=input('Add more? no = [enter], yes = 0 ');
while q==0
    figure(2)
    M = imfreehand(gca,'Closed',0);
    pts=unique(round(M.getPosition),'rows');
%     [xpts,ypts]=ginputc('Color','w','ShowPoints',true,'ConnectPoints',false);
%     pts=round([xpts,ypts]);
    tempmask=bwselect(logical(mask)-newmask,pts(:,1),pts(:,2),4);
    newmask=newmask+tempmask;
    clear pts tempmask
    figure(2)
    imshowpair(mask,uint8(newmask))
    q=input('Add more? no = [enter], yes = 0 ');
end
clear q
newmask=uint8(newmask);
imfinal=imnew.*newmask;
mask=newmask;