for i=1:1:size(IMAGEbody,3)
    display(['frame number: ',num2str(i)]); 
    im=IMAGEcrop(:,:,i);
    imnew=imadjust(im,[0,0.5],[0,1]);
    imfinal=IMAGEbody(:,:,i);
    mask=MASKbody(:,:,i);
    figure(1)
    imshow(logical(mask))
    pause(0.1)
	masknew=uint8(imfill(logical(mask),'holes'));
    imshow(logical(masknew))
    pause(0.1)
    imfinal=imnew.*masknew;
	IMAGEbody(:,:,i)=imfinal;
    MASKbody(:,:,i)=masknew;
end

