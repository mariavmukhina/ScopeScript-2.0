function varargout = printCurrentEpiLightSourceState(varargin)
%PRINTCURRENTLEDSTATE prints current Toptica Laser and Retra UV LED state

global mmc;

I340 = '0';%num2str(str2double(mmc.getProperty('Retra UV LED', 'UV340_Intensity')));
I380 = '0';%num2str(str2double(mmc.getProperty('Retra UV LED', 'UV380_Intensity')));
I488 = num2str(str2double(mmc.getProperty('iChrome-MLE','Laser 3: 3. Level %')));
I561 = num2str(str2double(mmc.getProperty('iChrome-MLE','Laser 2: 3. Level %')));
I640 = num2str(str2double(mmc.getProperty('iChrome-MLE','Laser 1: 3. Level %')));

output = 'Ch_340=%s Ch_380=%s Ch_488=%s Ch_561=%s Ch_640=%s';

TTLtrigger = char(varargin);

if isempty(TTLtrigger)
    if nargout == 0
       fprintf(output,I340,I380,I488,I561,I640); 
       fprintf('\n');
    else
       varargout{1} = sprintf(output,I340,I380,I488,I561,I640);
    end
else
    keySet =   {'UVTTL','Laser488TTL', 'Laser561TTL', 'Laser640TTL','Laser561&640'};
    valueSet = {{I340,I380},{I488},{I561},{I640},{I561,I640}};
    mapChannelsIntensity = containers.Map(keySet,valueSet);
    if isKey(mapChannelsIntensity,TTLtrigger)
        valueSetNames = {{'I340_','I380_'},{'I488_'},{'I561_'},{'I640_'},{'I561_','I640_'}};
        mapChannelsNames = containers.Map(keySet,valueSetNames);
        intensity = mapChannelsIntensity(TTLtrigger);
        names = mapChannelsNames(TTLtrigger);
        k = cellfun(@(x) strcmp(x,'0'),intensity);
        intensity(k == 1) = [];
        names(k == 1) = [];
        varargout{1} = cellfun(@(x,y)[x y],names,intensity,'uni',false);

        if isempty(varargout{1})
            varargout{1} = 'I_0';
        elseif numel(varargout{1}) > 1
            varargout{1} = join(varargout{1},'_');
        end
    else
        varargout{1} = '';
    end
end

end

