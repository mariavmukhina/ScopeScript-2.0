function [] = initMicroscope()
global mmc;
global showROI;
parpool();

disp('!!! all hardware shoould be on at the moment of initialization for it to run successfully !!!');
disp('you can turn off any unused hardware after initialization');

turnOffAllLEDs();

%close epifluor excitation shutter
closeTurretShutter();
mmc.setAutoShutter(0);

%set accuracy of Nikon XY stage
fastStage();

%start the camera
initAndorIXon(); %user-defined ROI may be selected to be shown as a white rectangle in all acquired images
showROI = [1, 1, 1024, 1024];

%print all the filtercubes in Nikon turret
printAvailableFilterCubes();

%initialize laser
initLaser();

%initialize UV LED
initUVLED();

%holdPiezoBF keeps stage TTL constant, BF TTL constant, PL is TTL triggered
holdPiezoBF();

end