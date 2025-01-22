function [] =  turnOffCameraToggles()
%TURNOFFCAMERATOGGLES sets pins to PORTF = B00000010 (BF on) and turns off Arduino's interruptPin (camera cannot toggle light sources)
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'o','');

% switch state of BF to inactive that, in conjunction with high TTL trigger, allows for manual control
turnOffBFLED();
end