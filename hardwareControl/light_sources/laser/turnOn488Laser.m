function [] = turnOn488Laser(energy)

global mmc;

mmc.setProperty('iChrome-MLE','Laser 3: 1. Enable','1');
mmc.setProperty('iChrome-MLE','Laser 3: 2. Emission','1');
mmc.setProperty('iChrome-MLE','Laser 3: 3. Level %',energy);
mmc.setProperty('iChrome-MLE','Laser 3: 4. Use TTL','0');
mmc.setProperty('iChrome-MLE','Laser 3: 5. Analog Mode','0');


end