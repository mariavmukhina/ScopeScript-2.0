function [] = setupChannel(varargin)
%SETUPCHANNEL sets the appropriate channel with correct energyLevel
% setupChannel() lists all the channels available
% setupChannel('channel',energy) sets a channel with intensity[%] = energy; the channel can be either PL or BF
% setupChannel('channel',{energy1,energy2}) % sets a channel with multiple PL excitation bands
% setupChannel('led-BF',100); % sets the bright field LED intensity without touching the fluorescent filter cube settings
% by default, this function issues a pause if the channel changes

%% check if no argument, if so, just return avaialable filter cubes
if nargin == 0
    printAvailableChannels();

    return;
end

%% arguments
channel = varargin{1};
energy  = varargin{2};

%% setup channel
if contains(channel,'BF')
    %% if the channel is brightfield, set the intensity
    turnONBFLED(energy)
    return;
else
    %% if the channel is fluorescent, execute filter cube change and update Toptica laser or Retra LED parameters
    global mmc;
    currFilterCube = getCurrentFilterCube();
    newFilterCube = mapChannelToFilterCube(channel);
    fcScope = scopeParams();
    pauseTimeFilterCube = fcScope.pauseTimeFilterCube;

    % make sure that BF LED is off
    turnOFFBFLED();

    %update laser or led
    switch channel

        %UV LED
        case {'led-340'}
            mmc.setProperty('UV LED', 'UV340_Intensity', energy);
            mmc.setProperty('UV LED', 'UV380_Intensity', '0');
        case {'led-380'}
            mmc.setProperty('UV LED', 'UV340_Intensity', '0');
            mmc.setProperty('UV LED', 'UV380_Intensity', energy);

        %lasers    
        case 'laser-488'
            mmc.setProperty('iChrome-MLE','Laser 1: 3. Level %','0');
            mmc.setProperty('iChrome-MLE','Laser 2: 3. Level %','0');
            mmc.setProperty('iChrome-MLE','Laser 3: 3. Level %',energy);
        case 'laser-561'
            mmc.setProperty('iChrome-MLE','Laser 1: 3. Level %','0');
            mmc.setProperty('iChrome-MLE','Laser 2: 3. Level %',energy);
            mmc.setProperty('iChrome-MLE','Laser 3: 3. Level %','0');
        case 'laser-640'
            mmc.setProperty('iChrome-MLE','Laser 1: 3. Level %',energy);
            mmc.setProperty('iChrome-MLE','Laser 2: 3. Level %','0');
            mmc.setProperty('iChrome-MLE','Laser 3: 3. Level %','0');
        case 'laser-561-640'
            if iscell(energy)
                energy1 = energy{1};
                energy2 = energy{2};
            else
                error('Multi-color channel requires {energy1,energy2} in a cell array');
            end
            mmc.setProperty('iChrome-MLE','Laser 1: 3. Level %',energy2);
            mmc.setProperty('iChrome-MLE','Laser 2: 3. Level %',energy1);
            mmc.setProperty('iChrome-MLE','Laser 3: 3. Level %','0');
        otherwise
            error(['unknown channel:' channel]);
    end
    
    if ~strcmp(newFilterCube,currFilterCube)
        % execute fluorescent filter cube change
        setFilterCube(newFilterCube);
    
        disp(['pausing ' num2str(pauseTimeFilterCube) ' sec(s) to wait for vibrations to go down...']);
        pause(pauseTimeFilterCube);
        
        if iscell(energy)
            disp(['channel changed to ' channel ' with energy ' insertAStringBetweenCells(',',energy)]);
        else
            disp(['channel changed to ' channel ' with energy ' insertAStringBetweenCells(',',{energy})]);
        end
    end  
 end

end
