clc; clear; close all;warning('off')

% dir='/Volumes/DeepPIV-1/150811_DeepPIV_WesternFlyer/';
dir='/Volumes/DeepPIV/150811_DeepPIV_WesternFlyer/';
data='lcmlog_2015_08_11_00.mat';
% load([dir,data])

datafile=matfile([dir,data]);
% varlist=who(datafile)

DVL=datafile.LCNAV_RTIDVL_NMEA_DVL;
stime=DVL.utime/1e6; %in seconds since 1970
stime=stime-stime(1);
speed=DVL.wtv;

MINIROV=datafile.LCNAV_MINIROV_DEPTH;
dtime=MINIROV.utime/1e6;
dtime=dtime-dtime(1);
depth=MINIROV.depth;

index=find(speed(:,1)>-90);
newstime=stime(index);
xvel=speed(index,1);
magvel=xvel;
% yvel=speed(index,2);
% zvel=speed(index,3);
% magvel=sqrt(xvel.^2+yvel.^2+zvel.^2);
% if rem(size(magvel,1),2)==0
%     fix=1;
% else
%     fix=0;
% end
% magvelnew=sgolayfilt(magvel(1:size(magvel,1)),9,size(magvel,1)-fix);
% min(magvelnew)

% windowSize = 5;
% b = (1/windowSize)*ones(1,windowSize);
% a=1;
% y = filter(b,a,magvel);

figure(1)
[hAx,~,~]=plotyy(dtime,depth,newstime,magvel);
grid on
xlabel('Time (s)')
ylabel(hAx(1),'Depth (m)')
ylabel(hAx(2),'Velocity magnitude (m/s)')

% figure(2)
% [hAx,h1,h2]=plotyy(dtime,depth,newstime,magvelnew-min(magvelnew));

newindex=find(depth<=0);
dtime(newindex)=[];
depth(newindex)=[];
tstart=dtime(1);
dtime=dtime-dtime(1);
newindex=min(find(newstime>tstart));
newstime(1:newindex)=[];
tstart=newstime(1);
newstime=newstime-tstart;
magvel(1:newindex)=[];%magvel=magvel-min(magvelnew);

%% filtering data
% windowSize = 2;
% b = (1/windowSize)*ones(1,windowSize);
% a=1;
% y = filter(b,a,magvel);
cutoff_freq_hz=0.5;
sample_freq_hz=2;
wn=cutoff_freq_hz/(0.5*sample_freq_hz);
[B,A] = butter(10,wn,'low');
ybutt=filter(B,A,magvel);
% if rem(size(magvel,1),2)==0
%     fix=1;
% else
%     fix=0;
% end
% magvelsm=sgolayfilt(magvel(1:size(magvel,1)),9,size(magvel,1)-fix);

%%
figure(3)
[hAx,h1,h2]=plotyy(dtime,depth,newstime,ybutt);
%????patch([0,0,14000,14000],[0.1,-0.1,-0.1,0.1],[0.8,0.8,0.8])
grid on
xlabel('Time (s)')
ylabel(hAx(1),'Depth (m)','FontSize',16)
ylabel(hAx(2),'X-Velocity (m/s)','FontSize',16)
% ylabel(hAx(2),'Velocity magnitude (m/s)','FontSize',16)
h1.LineWidth=2;h2.LineWidth=2;
set(hAx(1),'YDir','reverse','YLim',[0,300],'FontSize',14,'YTick',[0,50,100,150,200,250,300])
set(hAx(2),'YLim',[-2,2],'FontSize',14,'YTick',[-2,-1.5,-1,-0.5,0,0.5,1,1.5,2]);
axes(hAx(1))
hold on
plot([4237,4237],[0,300],[4427,4427],[0,300],[4681,4681],[0,300],[5604,5604],[0,300],[6657,6657],[0,300],[9397,9397],[0,300],[10244,10244],[0,300],[13064,13064],[0,300],'LineWidth',2,'LineStyle','--','Color','k')
plot([0,0],[0,300],[7654,7654],[0,300],[8900,8900],[0,300],[9574,9574],[0,300],[10244,10244],[0,300],[13064,13064],[0,300],'LineWidth',2,'LineStyle','--','Color',[0.7,0.7,0.7])
hold off
axes(hAx(2))
hold on
plot([0,14000],[0.1,0.1],'k',[0,14000],[-0.1,-0.1],'k');
hold off
% set(h1,'ylabel','Depth (m)','LineWidth',2)
% h1.LineStyle='.';

% figure(3)
% [hAx,h1,h2]=plotyy(dtime,depth,newstime,ybutt);
