function [] = turnOnUV380()

global mmc;

mmc.setProperty('UV LED','UV380','1');

end