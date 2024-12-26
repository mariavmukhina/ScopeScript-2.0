function arduinoPortVal = mapChannelToTTLPin(varargin)
%MAPCHANNELTOTTLPIN returns the mapping between illumination channels (BF (Peka LED) and PL (Toptica Laser and Retra UV LED)) and pins of the Arduino hardware controller, 
% so the arduino triggers the correct leds for the corresponding channel
% valueSet is provided as decimal numbers to be sent as 8-bit binary input
% to Arduino's PORTF corresponding to analog pins A0-A7
 

keySet =   {'UVTTL','Laser488TTL', 'Laser561TTL', 'Laser640TTL','Laser561&640','BrightFieldTTL'};

%old
%keySet =   {'AllFourTTL', 'ChDTTL', 'ChCTTL', 'ChBTTL','ChATTL','ChABTTL','ChBCTTL','ChABCTTL','BrightFieldTTL','AllOnTTL'};
%old
%valueSet = [1, 2, 4, 8, 16, 24, 12, 28, 64, 65];

valueSet = [1, 2, 4, 8, 12, 64];
%Decimal	8-bit Binary
% 1	    00000001
% 2	    00000010
% 4	    00000100
% 8	    00001000
% 16	00010000
% 24	00011000
% 12	00001100
% 28	00011100
% 64	01000000
% 65	01000001


if nargin == 0
    display(insertAStringBetweenCells(',',keySet));
    return;
else
   channel = varargin{1}; 
end

mapObj = containers.Map(keySet,valueSet);
if iscell(channel)
    arduinoPortVal = cellfun(@(x) mapObj(x),channel);
else
    arduinoPortVal = mapObj(channel);
end

end

