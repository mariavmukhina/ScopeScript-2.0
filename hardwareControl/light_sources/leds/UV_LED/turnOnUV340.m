function [] = turnOnUV340()

global mmc;

mmc.setProperty('UV LED','UV340','1');

end