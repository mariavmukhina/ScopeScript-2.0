function [ ] = finishExperiment()
%finishExperiment is to be run at the end of an experiment.
%It does the following:

% (1) sets TTL triggers for all illumination channels (Laser, UV LED, BF LED) to zero
% (2) moves z stage to zero position
% (3) turns off Arduino's interruptPin (camera cannot toggle light sources)

resetZStackToZero();

% (4) sets all PL and BF light sources to inactive state with zero intensities (via serial interface)
turnOffAllEpiChannels();
turnOffBFLED();

% (5) stops camera aquisition in case of the emergency script shutoff 
% (6) turns off EM gain on Andor camera
stopStreaming();
BF();

global mmc;
% (7) clean up µManager: clear all notifications on internal events 
mmc.registerCallback([]);
% (8) unload all devices from the core, clears all configuration data
mmc.reset();

DebugLogger.writeDebugMessage("Ending Experiment");
DebugLogger.close();

end

