function [ ] = finishExperiment()
%finishExperiment is to be run at the end of an experiment to turn off all the LEDs

%holdPiezoBF keeps stage TTL constant, BF TTL constant, PL is TTL triggered
holdPiezoBF();

%sets all PL LEDs to inactive state with zero intensities (including laser)
turnOffAllEpiChannels();

end

