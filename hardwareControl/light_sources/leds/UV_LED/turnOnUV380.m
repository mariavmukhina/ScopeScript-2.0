function [] = turnOnUV380()

global mmc;

mmc.setProperty('Retra UV LED','UV380','1');

end