function [] = turnOnRedLaser()

global mmc;

mmc.setProperty('iChrome-MLE','Laser 1: 1. Enable','1');
mmc.setProperty('iChrome-MLE','Laser 1: 2. Emission','1');
mmc.setProperty('iChrome-MLE','Laser 1: 3. Level %','1');
mmc.setProperty('iChrome-MLE','Laser 1: 4. Use TTL','0');
mmc.setProperty('iChrome-MLE','Laser 1: 5. Analog Mode','0');


end