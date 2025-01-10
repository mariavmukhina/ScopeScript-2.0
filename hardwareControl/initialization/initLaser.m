function [] = initLaser()

    global mmc;

    
    disp('initializing laser');
    disp('allow at least 30 sec for laser warm-up');
   
    mmc.setProperty('iChrome-MLE','All: 1. Enable','1');
    mmc.setProperty('iChrome-MLE','All: 2. Emission','0');
    mmc.setProperty('iChrome-MLE','All: 3. TTL Enable','1');
    mmc.setProperty('iChrome-MLE','All: 4. TTL High Active','1');
    mmc.setProperty('iChrome-MLE','All: 5. TTL Master Mode','0');
    mmc.setProperty('iChrome-MLE','All: 6. Analog Mode','0');

    switchLAPPMainBranchMirror(1);

end