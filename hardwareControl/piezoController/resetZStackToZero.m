function [] = resetZStackToZero()
%RESETZSTACKTOZERO sets the piezo stage to zero


global mmc;
comPort = scopeParams.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'a','');
if waitForArduinoConfirmation() == 1
   disp('----resetZStackToZero()--------------');
   disp('zstack reset to zero...'); 
end


end

