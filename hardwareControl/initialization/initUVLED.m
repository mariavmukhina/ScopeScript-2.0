function [] = initUVLED()

global mmc;
disp('initializing UV LED');
mmc.setProperty('Retra UV LED','State','1');

end