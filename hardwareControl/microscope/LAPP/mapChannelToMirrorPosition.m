function position = mapChannelToMirrorPosition(channel)
%MAPCHANNELTOMIRRORPOSITION returns the mapping between LED and laser channels (UV ( Retra LED) and laser (Toptica)) and position of the mirror on Ti2 LAPP Main Branch
%LED - position 2
%Laser - position 1

if ismember(channel,{'laser-488', 'laser-561', 'laser-640','laser-561-640'})
    position = 1;
elseif ismember(channel,{'led-340', 'led-380'})
     position = 2;
elseif strcmp(channel,'led-BF')
     position = []; 
end

