function [] = initAndorIXon()
global mmc;
global ti2;
disp('initializing Andor iXon');
ti2.LightPath.Value = 4;
mmc.setCameraDevice('Andor');
mmc.setProperty('Andor','BaselineClamp','Enabled');
mmc.setProperty('Andor','CCDTemperatureSetPoint','-75');
% disp('==========================================================================================================')
% disp('Waiting for sensor to cool down to -75C');
% disp('!!!For temperature stability turn on water cooling!!!! Make sure the water temperature is set to 10 C');
% sensorTemp = mmc.getProperty('Andor','CCDTemperature');
% while strcmp(sensorTemp,'-75')~=1 && strcmp(sensorTemp,'-74')~=1 && strcmp(sensorTemp,'-73')~=1
%     sensorTemp = mmc.getProperty('Andor','CCDTemperature');
%     disp(['Sensor temperature is ' char(sensorTemp)]);
%     pause(30);
% end
disp('Sensor temperature is set to -75C');
% disp('==========================================================================================================')
%mmc.setProperty('Andor','Force Run Till Abort','On');
mmc.setProperty('Andor','EMSwitch','Off');
mmc.setProperty('Andor','FanMode','Full');
mmc.setProperty('Andor','FrameTransfer','Off');
mmc.setProperty('Andor','Output_Amplifier','Electron Multiplying');
mmc.setProperty('Andor','Pre-Amp-Gain','Gain 2');
mmc.setProperty('Andor','ReadMode','Image');
mmc.setProperty('Andor','Region of Interest','Full Image');
mmc.setProperty('Andor','Shutter (External)','Open');
mmc.setProperty('Andor','Shutter (Internal)','Open');
mmc.setProperty('Andor','Shutter Closing Time','0');
mmc.setProperty('Andor','Shutter Opening Time','0');
mmc.setProperty('Andor','SpuriousNoiseFilter','None');
mmc.setProperty('Andor','Trigger','Software');

%set camera to CCD mode, EM = 0
BF();  

end