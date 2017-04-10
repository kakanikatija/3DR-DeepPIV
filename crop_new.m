function hfig=crop_new(IMAGE)

sizeIm=size(IMAGE);
wa=images.internal.getWorkArea;
screenwidth=wa.width;screenheight=wa.height;
minSlice=1;maxSlice=sizeIm(3);startSlice=minSlice;
minCrop=1;maxHCrop=sizeIm(2);maxVCrop=sizeIm(1);
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
htxt1=uicontrol('Style','text','Position',[width*0.5-sliderlength*0.5 40 textlength 20],'String',['Slice: ',num2str(startSlice)],'HorizontalAlignment','left');
slider1=uicontrol('Parent',hfig,'Style','slider','Callback',@slider1_Callback,'String','Slice Number','Units','pixels','Position',[width*0.5-sliderlength*0.5 20 sliderlength 20]);%,'SliderStep',[smallStep largeStep]);
set(slider1,'Min',minSlice,'Max',maxSlice,'Value',startSlice)
htxt4=uicontrol('Style','text','Position',[width-sliderlength 120 textlength 20],'String',['Left Crop: ',num2str(minCrop)],'HorizontalAlignment','left');
slider4=uicontrol('Parent',hfig,'Style','slider','Callback',@slider4_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 100 sliderlength 20],'SliderStep',[0.05 0.25]);
set(slider4,'Min',minCrop,'Max',maxHCrop,'Value',minCrop)
htxt5=uicontrol('Style','text','Position',[width-sliderlength 80 textlength 20],'String',['Right Crop: ',num2str(maxHCrop)],'HorizontalAlignment','left');
slider5=uicontrol('Parent',hfig,'Style','slider','Callback',@slider5_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 60 sliderlength 20],'SliderStep',[0.05 0.25]);
set(slider5,'Min',minCrop,'Max',maxHCrop,'Value',maxHCrop)
htxt6=uicontrol('Style','text','Position',[width-sliderlength 160 textlength 20],'String',['Bottom Crop: ',num2str(minCrop)],'HorizontalAlignment','left');
slider6=uicontrol('Parent',hfig,'Style','slider','Callback',@slider6_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 140 sliderlength 20],'SliderStep',[0.05 0.25]);
set(slider6,'Min',minCrop,'Max',maxVCrop,'Value',maxVCrop)
htxt7=uicontrol('Style','text','Position',[width-sliderlength 200 textlength 20],'String',['Top Crop: ',num2str(maxVCrop)],'HorizontalAlignment','left');
slider7=uicontrol('Parent',hfig,'Style','slider','Callback',@slider7_Callback,'String','Threshold','Units','pixels','Position',[width-sliderlength 180 sliderlength 20],'SliderStep',[0.05 0.25]);
set(slider7,'Min',minCrop,'Max',maxVCrop,'Value',minCrop)
button=uicontrol('Parent',hfig,'Style','pushbutton','Callback',@button_Callback,'String','Finish','Units','pixels','Position',[width-textlength 20 spacer 20]);

slice=get(slider1,'Value');
    if slice<minSlice || slice>maxSlice
        slice=minSlice;
    end
LCrop=get(slider4,'Value');
    if LCrop<minCrop || LCrop>maxHCrop
        LCrop=minCrop;
    end
RCrop=get(slider5,'Value');
    if RCrop<minCrop || RCrop>maxHCrop
        RCrop=maxHCrop;
    end
BCrop=get(slider6,'Value');
    if BCrop<minCrop || BCrop>maxVCrop
        BCrop=minCrop;
    end
TCrop=get(slider7,'Value');
    if TCrop<minCrop || TCrop>maxVCrop
        TCrop=maxVCrop;
    end
    
% axes('Position',[0,0.1,0.8,0.8])
imshow(IMAGE(:,:,slice),[]);
hold on
plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
hold off
%%
    function []=slider1_Callback(slider1,~,~)
        slice=round(get(slider1,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(IMAGE(:,:,slice),[]);
        hold on
        plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
        plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
        hold off
        set(htxt1,'String',['Slice: ',num2str(slice)]);
    end
%%
    function []=slider4_Callback(slider4,~,~)
        LCrop=round(get(slider4,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(IMAGE(:,:,slice),[]);
        hold on
        plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
        plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
        hold off
        set(htxt4,'String',['Left Crop: ',num2str(LCrop)]);
    end
%%
    function []=slider5_Callback(slider5,~,~)
        RCrop=round(get(slider5,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(IMAGE(:,:,slice),[]);
        hold on
        plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
        plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
        hold off
        set(htxt5,'String',['Right Crop: ',num2str(RCrop)]);
    end
%%
    function []=slider6_Callback(slider6,~,~)
        BCrop=round(get(slider6,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(IMAGE(:,:,slice),[]);
        hold on
        plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
        plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
        hold off
        set(htxt6,'String',['Bottom Crop: ',num2str(TCrop)]);
    end
%%
    function []=slider7_Callback(slider7,~,~)
        TCrop=round(get(slider7,'Value'));
%         axes('Position',[0,0.1,0.8,0.8])
        imshow(IMAGE(:,:,slice),[]);
        hold on
        plot([LCrop,LCrop],[minCrop,maxVCrop],'w--',[RCrop,RCrop],[minCrop,maxVCrop],'w--')
        plot([minCrop,maxHCrop],[TCrop,TCrop],'w--',[minCrop,maxHCrop],[BCrop,BCrop],'w--')
        hold off
        set(htxt7,'String',['Top Crop: ',num2str(BCrop)]);
    end
%%
    function []=button_Callback(button,~,~)
        output.LCrop=LCrop;
        output.RCrop=RCrop;
        output.TCrop=TCrop;
        output.BCrop=BCrop;
        assignin('caller','output',output);
        close; return
    end

end