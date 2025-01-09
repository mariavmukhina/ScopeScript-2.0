function [] = cameraTogglesPL()
%CAMERATOGGLESPL keeps stage constant and toggles (!)ALL epi channels on and off when triggered by the camera 
%PORTF = B00001111
disp('set piezo to holding and toggle PL channel...');
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'f','');
end
