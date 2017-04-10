function [dir,start,finish,fps,fstop,shutter,calib,red,aspectratio,contrast]=videoinfo(dataset,vel)
 
red=1;
aspectratio=[1,1,1];
contrast=[0 1];
if strcmp(dataset,'60p_f13_250sh')==1
    if vel==10
        start=1;
        finish=230;
    elseif vel==50
        start=1701;
        finish=1760;
    elseif vel==100
        start=2172;
        finish=2220;
    elseif vel==150
        start=2500;
        finish=2530;
    elseif vel==200
        start=2788;
        finish=2810;
    end
    dir='/Volumes/HD1/Users/kakani/Desktop/150416_LabTest_3DR/';
    fps=60;
    fstop=13;
    shutter=250;
    calib=10; %pixels/mm
    contrast=[10 58]/255;
%     contrast=[2 36]/255;
%     contrast=[38/255 61/255];
elseif strcmp(dataset,'60p_f11_60sh')==1
    if vel==10
        start=0;
        finish=0;
    elseif vel==50
        start=0;
        finish=0;
    elseif vel==100
        start=0;
        finish=0;
    elseif vel==150
        start=0;
        finish=0;
    elseif vel==200
        start=0;
        finish=0;
    end
    fps=60;
    fstop=11;
    shutter=60;
    calib=10.1; %pixels/mm
    dir='';
elseif strcmp(dataset,'00037_converted(1)')==1
    if vel==10
        start=400;
        finish=920;
    elseif vel==50
        start=2180;
        finish=2350;
    elseif vel==100
        start=2676;
        finish=2776;
    elseif vel==150
        start=3017;
        finish=3097;
    elseif vel==200
        start=3267;
        finish=3372;
    end
    fps=60;
    fstop=1;    %no idea
    shutter=60; %default setting to 1/fps
    calib=6; %pixels/mm; 
    dir='/Users/kakani/Desktop/150721_LabTest_3DR/';
    red=1;
    aspectratio=[1,1,1];
    contrast=[10/255,60/255];
elseif strcmp(dataset,'150522_SC1ATK22_3DR_10')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150522_TankTesting_3DR/';
    start=1416;
    finish=1604;
    fps=60;
    fstop=0;
    shutter=60;
    calib=2; %pixels/mm
    red=1;
    contrast=[2 138]/255;
    aspectratio=[1,1,2];
elseif strcmp(dataset,'150601_batho')==1
    dir='';
    start=1;
    finish=381;
    fps=60;
    fstop=0;
    shutter=60;
    calib=50; %pixels/mm   %UNKNOWN
elseif strcmp(dataset,'150727_SC1ATK42_bathos_10')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150727_RachelCarson_DeepPIV/';
    start=117;
    finish=729;
    fps=60;
    fstop=0;
    shutter=60;
    calib=95*10; %pixels/mm   
elseif strcmp(dataset,'150811_DeepPIV_BathoMcnutti_1')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=204;
    finish=543;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm   
    aspectratio=[1.5,1.5,1];
elseif strcmp(dataset,'150811_DeepPIV_Fritillaria_3DR_1')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=1;
    finish=305;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm   
    aspectratio=[3,3,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_med')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=132;
    finish=305;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm   
    aspectratio=[3,3,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_small')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=1;
    finish=413;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm   
    aspectratio=[1,1,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_medsmall')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=67;
    finish=273;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm   
    aspectratio=[2,2,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_medlarge')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=1;
    finish=352;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm  
    red=0;
    aspectratio=[3,3,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_large_bw')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=1;
    finish=876;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm  
    red=0;
    aspectratio=[3,3,1];
elseif strcmp(dataset,'150811_DeepPIV_BathoStyg_3DR_xlarge')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/150811_WesternFlyer_DeepPIV/';
    start=1;
    finish=471;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[3,3,1];
    contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK62_Batho_10')==1
%     dir='/Users/kakani/Desktop/151120_RachelCarson_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=173;
    finish=579;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK62_Batho_11')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
%     dir='/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=53;
    finish=579;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK62_Batho_27')==1
%     dir='/Users/kakani/Desktop/151120_RachelCarson_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=55;
    finish=977;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151202_SC1ATK65_Ctenophore_7')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151202_WesternFlyer_DeepPIV/';
    start=282;
    finish=506;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151202_SC1ATK64_EggMass_2')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151202_WesternFlyer_DeepPIV/';
    start=31;
    finish=340;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_8')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151202_WesternFlyer_DeepPIV/';
    start=149;
    finish=863;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_9')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151202_WesternFlyer_DeepPIV/';
    start=91;
    finish=470;
    fps=60;
    fstop=0;
    shutter=30;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151202_SC1ATK64_Desmophyes_10')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151202_WesternFlyer_DeepPIV/';
    start=147;
    finish=354;
    fps=60;
    fstop=0;
    shutter=30;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_11')==1
%     dir='/Users/kakani/Desktop/151120_RachelCarson_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=124;
    finish=631;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_14')==1
%     dir='/Users/kakani/Desktop/151120_RachelCarson_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=17;
    finish=197;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151120_SC1ATK61_Oikopleura_17')==1
%     dir='/Users/kakani/Desktop/151120_RachelCarson_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151120_RachelCarson_DeepPIV/';
    start=137;
    finish=411;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151205_SC1ATK68_Batho_2')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151205_WesternFlyer_DeepPIV/';
    start=647;
    finish=803;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'151205_SC1ATK67_Batho_4')==1
%     dir='/Users/kakani/Desktop/151202_WesternFlyer_DeepPIV/';
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_field/151205_WesternFlyer_DeepPIV/';
    start=696;
    finish=863;
    fps=60;
    fstop=0;
    shutter=60;
    calib=1; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
elseif strcmp(dataset,'Part1')==1
    dir='/Volumes/HD1/Users/kakani/Desktop/DeepPIV_lab/150416_LabTest_3DR/';
    start=1;
    finish=1;
    fps=60;
    fstop=0;
    shutter=60;
    calib=9; %pixels/mm
    aspectratio=[1,1,1];
%     contrast=[2 100]/255;
end