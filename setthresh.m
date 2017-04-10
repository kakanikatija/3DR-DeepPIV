function [plane] = setthresh(plane,thresh)

index=find(plane<thresh);
plane(index)=0;
