function filterCube = mapChannelToFilterCube(channel)
%MAPCHANNELTOFILTERCUBE returns the mapping between LED and laser channels (UV ( Retra LED) and laser (Toptica)) and filter cubes  

if ismember(channel,{'laser-488', 'laser-561', 'laser-640','laser-561-640'})
    filterCube = '1-QUAD';
elseif strcmp(channel,'led-340')
     filterCube = '1-QUAD'; % FIX!!!!!!!!!!!!
elseif strcmp(channel,'led-380')
     filterCube = '1-QUAD'; % FIX!!!!!!!!!!!!!
end

