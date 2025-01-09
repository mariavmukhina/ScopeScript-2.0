function [] = resetZStack()
%RESETZSTACK sets the piezo stage to initial position selected by user
global mmc;
comPort = scopeParams.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'r','');
if waitForArduinoConfirmation()
   disp('----resetZStack()--------------');
   disp('zstack reset to ready position...'); 
end


end

