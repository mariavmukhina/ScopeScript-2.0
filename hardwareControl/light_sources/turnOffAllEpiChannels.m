function [] = turnOffAllEpiChannels()

global mmc;

%Turn Toptica Laser off
disp('Lasers disabled');
mmc.setProperty('iChrome-MLE','All: 1. Enable','0');

% Turn Retra UV LED off
%disp('UV LEDs disabled')
%mmc.setProperty('Retra UV LED', 'State', '0'); 

end