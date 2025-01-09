function [] = cameraTogglesBF()
%CAMERATOGGLESBF keeps stage constant and toggles BF channel on and off when triggered by the camera
%PORTF = B01000000
disp('set piezo to holding and toggle BF channel...');
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'b','');
end


