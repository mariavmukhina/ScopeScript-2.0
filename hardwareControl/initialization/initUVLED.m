function [] = initUVLED()

global mmc;
disp('initializing UV LED');
mmc.setProperty('Retra UV LED','State','1');
mmc.setProperty('Retra UV LED', 'UV340_Intensity', '0');
mmc.setProperty('Retra UV LED', 'UV380_Intensity', '0');

end