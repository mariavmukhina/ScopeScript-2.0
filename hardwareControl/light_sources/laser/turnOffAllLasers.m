function [] = turnOffAllLasers()

global mmc;

disp('Lasers disabled');
mmc.setProperty('iChrome-MLE','All: 1. Enable','0');

end