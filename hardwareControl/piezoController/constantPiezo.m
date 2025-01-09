function [] = constantPiezo()
%CONSTANTPIEZO holds stage, brightfield and fluorescent TTLs are constant and high (LEDs on)
%useful for testing the light sources
%doesn't have any dependancies
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;

mmc.setSerialPortCommand(comPort,'c','');

end

