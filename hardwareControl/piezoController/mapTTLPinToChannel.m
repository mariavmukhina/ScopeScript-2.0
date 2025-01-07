function arduinoPortVal = mapTTLPinToChannel(varargin)
%MAPTTLPINTOCHANNEL returns the mapping between pins of the Arduino hardware controller and illumination channels (BF (Peka LED) and PL (Toptica Laser and Retra UV LED)), 
% so the correct light source trigger is saved to meta data for the corresponding channel
% valueSet is provided as decimal numbers to be sent as 8-bit binary input
% to Arduino's PORTF corresponding to analog pins A0-A7


valueSet =   {'UVTTL','Laser488TTL', 'Laser561TTL', 'Laser640TTL','Laser561&640','BrightFieldTTL'};
keySet = [1, 2, 4, 8, 12, 64];

% Decimal	8-bit Binary   Arduino Pin     Device
% 1         00000001       A0              Retra UV LED
% 2	        00000010       A1              Toptica Laser 488
% 4	        00000100       A2              Toptica Laser 561
% 8	        00001000       A3              Toptica Laser 640
% 12        00001100       A2&3            Toptica Lasers 561&640
% 64	    01000000       A6              Peka Brightfield LED

if nargin == 0
    display(insertAStringBetweenCells(',',num2cell(keySet)));
    return;
else
   channel = varargin{1}; 
end

mapObj = containers.Map(keySet,valueSet);
if isvector(channel)
    arduinoPortVal = values(mapObj,num2cell(channel));
else
    arduinoPortVal = mapObj(channel);
end

end

