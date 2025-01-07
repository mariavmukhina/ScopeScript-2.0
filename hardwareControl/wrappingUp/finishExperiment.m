function [ ] = finishExperiment()
%finishExperiment is to be run at the end of an experiment to turn off all the LEDs

% set TTL triggers for all illumination channels (Laser, UV LED, BF LED) to zero
setAllLightSourceTTLsToZero();

%set all PL and BF light sources to inactive state with zero intensities
turnOffAllEpiChannels();
turnOffBFLED();

%holdPiezoBF keeps stage TTL constant, BF TTL constant, PL is TTL triggered
holdPiezoBF();

%turn off EM gain on Andor camera
BF();

end

