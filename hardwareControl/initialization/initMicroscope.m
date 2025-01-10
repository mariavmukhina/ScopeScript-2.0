function [] = initMicroscope()
global mmc;
global showROI;


disp('!!! all hardware shoould be on at the moment of initialization for it to run successfully !!!');
disp('you can turn off any unused hardware after initialization');
fprintf('\n\n');

%close epifluor excitation shutter
closeTurretShutter();
mmc.setAutoShutter(0);

%set accuracy of Nikon XY stage
fastStage();

%start the camera
initAndorIXon(); %user-defined ROI may be selected to be shown as a white rectangle in all acquired images
showROI = [1, 1, 1024, 1024];
fprintf('\n\n');

%initialize laser
initLaser();
fprintf('\n\n');

%initialize UV LED
initUVLED();
fprintf('\n\n');

%print all available illumination channels
printAvailableChannels();
fprintf('\n\n');

%cameraTogglesBF keeps stage constant and toggles BF channel on and off when triggered by the camera
cameraTogglesBF();

end