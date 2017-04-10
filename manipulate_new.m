function hfig=manipulate_new(IMAGE,output)

sizeIm=size(IMAGE);
wa=images.internal.getWorkArea;
screenwidth=wa.width;screenheight=wa.height;
minSlice=1;maxSlice=sizeIm(3);startSlice=minSlice;
minThresh=0;maxThresh=100;startThresh=minThresh;
minFilt=1;maxFilt=20;startFilt=minFilt;
smallStep=1;
largeStep=10;
sliderlength=300;
textlength=200;
spacer=100;
if screenwidth<sizeIm(2)
    width=screenwidth;
    height=screenheight;
else
    width=sizeIm(2);
    height=sizeIm(1);
end

hfig=figure('Toolbar','none','Menubar','none','Name','Slice Viewer','NumberTitle','on','IntegerHandle','off','Position',[0 0 width height]);
htxt=uicontrol('Parent',hfig,'Style','text','Position',[width-sliderlength height textlength 20],'String','Adjustable Parameters:','HorizontalAlignment','left');
htxt1=uicontrol('Style','text','Position',[width*0.5-sliderlength*0.5 40 textlength 20],'String',['Slice: ',num2str(startSlice)],'HorizontalAlignment','left');
slider1=uicontrol('Parent',hfig,'Style','slider','Callback',@slider1_Callback,'String','Slice Number','Units','pixels','Position',[width*0.5-sliderlength*0.5 20 sliderlength 20]);%,'SliderStep',[smallStep largeStep]);
set(slider1,'Min',minSlice,'Max',maxSlice,'Value',startSlice)
htxt2=uicontrol('Style','text','Position',[width-sliderlength 100 textlength 20],'String',['Threshold: ',num2str(startThresh)],'HorizontalAlignment','left');
slider2=uicontrol('Parent',hfig,'Style','slider','Callback',@slider2_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 80 sliderlength 20]);%,'SliderStep',[smallStep largeStep]);
set(slider2,'Min',minThresh,'Max',maxThresh,'Value',startThresh)
htxt3=uicontrol('Style','text','Position',[width-sliderlength 60 textlength 20],'String',['Medfilt: ',num2str(startFilt)],'HorizontalAlignment','left');
slider3=uicontrol('Parent',hfig,'Style','slider','Callback',@slider3_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 40 sliderlength 20],'SliderStep',[0.05 0.25]);
set(slider3,'Min',minFilt,'Max',maxFilt,'Value',startFilt)
button=uicontrol('Parent',hfig,'Style','pushbutton','Callback',@button_Callback,'String','Finish','Units','pixels','Position',[width-textlength 20 spacer 20]);

slice=get(slider1,'Value');
    if slice<minSlice || slice>maxSlice
        slice=minSlice;
    end
thresh=get(slider2,'Value');
    if thresh<minThresh || thresh>maxThresh
        thresh=minThresh;
    end
medfilt=get(slider3,'Value');
    if medfilt<minFilt || medfilt>maxFilt
        medfilt=minFilt;
    end
    
% axes('Position',[0,0.1,0.8,0.8])
imshow(medfilt2(setthresh(IMAGE(:,:,slice),thresh),[medfilt,medfilt],'symmetric'),[]);

%%
    function []=slider1_Callback(slider1,~,~)
        slice=round(get(slider1,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(medfilt2(setthresh(IMAGE(:,:,slice),thresh),[medfilt,medfilt],'symmetric'),[]);
        set(htxt1,'String',['Slice: ',num2str(slice)]);
    end
%%
    function []=slider2_Callback(slider2,~,~)
        thresh=round(get(slider2,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(medfilt2(setthresh(IMAGE(:,:,slice),thresh),[medfilt,medfilt],'symmetric'),[]);
        set(htxt2,'String',['Threshold: ',num2str(thresh)]);
    end
%%
    function []=slider3_Callback(slider3,~,~)
        medfilt=round(get(slider3,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(medfilt2(setthresh(IMAGE(:,:,slice),thresh),[medfilt,medfilt],'symmetric'),[]);
        set(htxt3,'String',['Medfilt2: ',num2str(medfilt)]);
    end
%%
    function []=button_Callback(button,~,~)
        output.thresh=thresh;
        output.filt=medfilt;
        assignin('caller','output',output);
        close; return
    end

end