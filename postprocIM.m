function newIMAGE=postprocIM(IMAGE,output)

tcrop=output.TCrop;
bcrop=output.BCrop;
lcrop=output.LCrop;
rcrop=output.RCrop;
thresh=output.thresh;
medfilt=output.filt;

IMAGE=IMAGE(tcrop:bcrop,lcrop:rcrop,:);
for i=1:1:size(IMAGE,3)
    newIMAGE(:,:,i)=medfilt2(setthresh(IMAGE(:,:,i),thresh),[medfilt,medfilt],'symmetric');
end

%%
    function [plane]=setthresh(plane,thresh)
    index=find(plane<thresh);
    plane(index)=0;
    end

end