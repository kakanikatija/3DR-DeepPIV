function makevideo(outfile)

axis vis3d off
for j=1:1:2
    if j==1
        mov(j)=getframe;
    else
%         axis vis3d off
        for i=1:180
            camorbit(2,0,'camera')
            drawnow
            mov(j)=getframe;
            j=j+1;
        end
        for i=1:180
            camorbit(0,2,'camera')
            drawnow
            mov(j)=getframe;
            j=j+1;
        end
    end
end
writerObj=VideoWriter(outfile,'MPEG-4');
open(writerObj);
writeVideo(writerObj,mov);
close(writerObj);