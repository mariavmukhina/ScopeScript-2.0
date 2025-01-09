function [] =  turnOffCameraToggles()
%TURNOFFCAMERATOGGLES sets pins to low: PORTF = B00000000 and turns off Arduino's interruptPin (camera cannot toggle light sources)
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'o','');
end