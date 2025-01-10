function [] = turnOnUV340()

global mmc;

mmc.setProperty('Retra UV LED','UV340','1');

end